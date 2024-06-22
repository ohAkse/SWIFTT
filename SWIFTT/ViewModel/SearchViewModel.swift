//
//  SearchViewModel.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Foundation
import Combine

@Observable class SearchViewModel: ObservableObject {
    deinit {
        Logger.writeLog(.info, message: "SearchViewModel deinit called")
    }
    
    var searchText: String = ""
    var searchItem: BookSearchItem?
    var searchStatus: SearchStatus = .idle
    var pageNumber: Int = 1
    var isNeededReload: Bool = false
    
    private var isLoadingPage = false
    private var cancellables = Set<AnyCancellable>()
    private var networkService:  NetworkFetchable
    
    init(networkService:  NetworkFetchable) {
        self.networkService = networkService
    }
    
    func onTappedSearchButton() {
        searchItem = nil
        pageNumber = 1
        searchBooks()
    }
    
    func loadNextPage() {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        pageNumber += 1
        searchBooks()
    }
    
    private func searchBooks() {
        guard !searchText.isEmpty else { return }
        
        let components = URLComponents().with {
            $0.scheme = "https"
            $0.host = "api.itbook.store"
            $0.path = "/1.0/search/\(searchText)/\(pageNumber)"
        }
        
        networkService.fetchItem(URLComp: components)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .decode(type: BookSearchItem.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.searchStatus = .fail
                    Logger.writeLog(.error, message: error.localizedDescription)
                case .finished:
                    self.searchStatus = .success
                    self.isLoadingPage = false
                }
            } receiveValue: { [weak self] queryItem in
                guard let self = self else { return }
                if self.pageNumber == 1 {
                    self.searchItem = queryItem
                } else {
                    self.searchItem?.books.append(contentsOf: queryItem.books)
                }
                self.isNeededReload = !queryItem.books.isEmpty
            }
            .store(in: &cancellables)
    }
}

