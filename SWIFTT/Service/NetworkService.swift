//
//  NetworkService.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Combine

protocol NetworkFetchable {
    associatedtype item
    var itemList: item { get }
    func fetchItem(forURL key: String) -> Future<Any?, Never>
}


class NetworkService: NetworkFetchable {
    var itemList: [SearchItem] = []
    
    func fetchItem(forURL key: String) -> Future<Any?, Never> {
        return Future { promise in
            let data = SearchItem(title: "Item 1")
            promise(.success(data))
        }
    }
}
