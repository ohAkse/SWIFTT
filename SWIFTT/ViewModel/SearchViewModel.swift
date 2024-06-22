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
    private var networkService: any NetworkFetchable
    
    init(networkService: any NetworkFetchable) {
        self.networkService = networkService
    }
    
    func onTappedSearchButton() {
        if let _ = searchItem {
            searchItem = nil
            pageNumber = 1
        }
        searchBooks()
    }
    func loadNextPage() {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        pageNumber += 1
        searchBooks()
    }
    
    private func searchBooks() {
        networkService.fetchItem(query: searchText, page: pageNumber)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .decode(type: BookSearchItem.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .failure(let error):
                    searchStatus = .fail
                    Logger.writeLog(.error, message: error.localizedDescription)
                case .finished:
                    searchStatus = .success
                    isLoadingPage = false
                }
            } receiveValue: { [weak self]  queryItem in
                guard let self = self else {return}
                if pageNumber == 1 {
                   searchItem = queryItem
                } else {
                   searchItem?.books.append(contentsOf: queryItem.books)
                }
                isNeededReload = !queryItem.books.isEmpty
            }
            .store(in: &cancellables)
    }
}
