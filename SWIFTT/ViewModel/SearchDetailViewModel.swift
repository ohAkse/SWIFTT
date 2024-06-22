//
//  SearchDetailViewModel.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI
import Combine

@Observable class SearchDetailViewModel: ObservableObject {
    deinit {
        Logger.writeLog(.info, message: "SearchDetailViewModel deinit called")
    }

    var searchStatus: SearchStatus = .idle
    var searchDetailItem: BookSearchDetailItem?
    
    private var isbn13: String = ""
    private var cancellables = Set<AnyCancellable>()
    private var networkService: any NetworkFetchable
    
    init(networkService: any NetworkFetchable) {
        self.networkService = networkService
    }
    
    func setQueryParam(isbn13: String) {
        self.isbn13 = isbn13
    }
    
    func searchDetailInfo() {
        networkService.fetchDetailItem(isbn: isbn13)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .decode(type: BookSearchDetailItem.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .failure(let error):
                    Logger.writeLog(.error, message: error.localizedDescription)
                    self.searchStatus = .fail
                case .finished:
                    self.searchStatus = .success
                }
            } receiveValue: { [weak self] searchDetailItem in
                guard let self = self else {return}
                self.searchDetailItem = searchDetailItem
            }
            .store(in: &cancellables)
    }
}
