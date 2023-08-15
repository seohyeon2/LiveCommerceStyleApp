//
//  NetworkManager.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/08.
//

import Foundation
 
final class NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func dataTask(api: APIRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let request = api.getRequest() else {
            return
        }

        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(NetworkingError.invalidHttpResponse))
            }

            guard let data = data else {
                return completion(.failure(NetworkingError.noData))
            }

            completion(.success(data))
        }.resume()
    }
}
