//
//  NetworkService.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Combine
import Foundation

protocol NetworkFetchable {
    func fetchItem(URLComp Comp: URLComponents)-> AnyPublisher<Data, URLError>
}


class NetworkService: NetworkFetchable {
    func fetchItem(URLComp Comp: URLComponents) -> AnyPublisher<Data, URLError> {
        guard let url = Comp.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in
                return data
            }
            .mapError { $0 as URLError }
            .eraseToAnyPublisher()
    }
}

