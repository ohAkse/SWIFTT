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
        resetSearch()
        searchBooks()
    }
    
    func loadNextPage() {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        pageNumber += 1
        searchBooks()
    }
    
    private func resetSearch() {
        searchItem = nil
        pageNumber = 1
    }
    
    private func searchBooks() {
        guard !searchText.isEmpty else { return }
        
        let components = makeURLComponents()
        
        networkService.fetchItem(URLComp: components)
            .decode(type: BookSearchItem.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] queryItem in
                self?.handleReceiveValue(queryItem)
            }
            .store(in: &cancellables)
    }
    
    private func makeURLComponents() -> URLComponents {
        return URLComponents().with {
            $0.scheme = "https"
            $0.host = "api.itbook.store"
            $0.path = "/1.0/search/\(searchText)/\(pageNumber)"
        }
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            searchStatus = .fail
            Logger.writeLog(.error, message: error.localizedDescription)
        case .finished:
            searchStatus = .success
            isLoadingPage = false
        }
    }
    
    private func handleReceiveValue(_ queryItem: BookSearchItem) {
        if pageNumber == 1 {
            searchItem = queryItem
        } else {
            searchItem?.books.append(contentsOf: queryItem.books)
        }
        isNeededReload = !queryItem.books.isEmpty
    }
}

