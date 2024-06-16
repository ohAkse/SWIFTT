//
//  SearchViewModel.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Foundation

class SearchViewModel<Service: NetworkFetchable>: ObservableObject  {
    deinit {
        Logger.writeLog(.info, message: "SearchViewModel deinit called")
    }
    
    @Published var searchText: String = ""
    @Published var searchItem: [SearchItem] = []
    @Published var isNeededReload = false
    
    private var networkService: Service
    
    init(networkService: Service) {
        self.networkService = networkService
    }
    func onTappedSearchButton() {
         if !searchText.isEmpty {
            searchText = ""
        }
        createDummyItem()
        
    }
    private func createDummyItem() {
        searchItem = [
            SearchItem(title: "Dummy Item 1"),
            SearchItem(title: "Dummy Item 2"),
            SearchItem(title: "Dummy Item 3")
        ]
        isNeededReload = true
    }
}
