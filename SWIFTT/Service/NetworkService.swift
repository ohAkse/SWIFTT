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
              .tryMap { data, response in
                  guard let httpResponse = response as? HTTPURLResponse else {
                      throw URLError(.badServerResponse)
                  }
                  
                  switch httpResponse.statusCode {
                  case 200:
                      return data
                  case 401:
                      throw URLError(.userAuthenticationRequired)
                  case 403:
                      throw URLError(.noPermissionsToReadFile)
                  case 404:
                      throw URLError(.fileDoesNotExist)
                  case 500:
                      throw URLError(.cannotConnectToHost)
                  case 504:
                      throw URLError(.timedOut)
                  default:
                      throw URLError(.unknown)
                  }
              }
              .mapError { $0 as? URLError ?? URLError(.unknown) }
              .eraseToAnyPublisher()
    }
}

