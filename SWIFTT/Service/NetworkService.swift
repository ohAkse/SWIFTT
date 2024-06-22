//
//  NetworkService.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Combine
import Foundation

protocol NetworkFetchable {
    associatedtype item
    var itemList: item { get }
    func fetchItem(query key: String, page number: Int) -> AnyPublisher<Data, URLError>
    func fetchDetailItem(isbn: String) -> AnyPublisher<Data, URLError>
}


class NetworkService: NetworkFetchable {
    var itemList: BookSearchItem?
    private var imageService: ImageCacheFetchable

    init(imageService: ImageCacheFetchable) {
        self.imageService = imageService
    }
    //다하고 나서 묶자..
    func fetchItem(query key: String = "", page number: Int = -99) -> AnyPublisher<Data, URLError> {
        let cacheKey = "\(key)_\(number)"
        
        if let cacheData = imageService.getCachedData(for: cacheKey) {
            
            return Just(cacheData)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.itbook.store"
        components.path = key.isEmpty ? "/1.0/search/\(key)" : "/1.0/search/\(key)/\(number)"
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in
                self.imageService.cacheData(data, for: cacheKey)
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func fetchDetailItem(isbn: String) -> AnyPublisher<Data, URLError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.itbook.store"
        components.path = "/1.0/books/\(isbn)"
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
