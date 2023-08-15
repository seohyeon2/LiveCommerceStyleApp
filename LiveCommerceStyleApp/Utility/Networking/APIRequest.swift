//
//  APIRequest.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/08.
//

import Foundation

protocol APIRequest {
    var baseURL: BaseURL { get }
    var path: Path? { get }
    var queries: [String: String]? { get }
    var method: HTTPMethod { get }
    
    func getRequest() -> URLRequest?
}

extension APIRequest {
    func getRequest() -> URLRequest? {
        guard let url = configureURL() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.name
        
        return request
    }
    
    private func configureURL() -> URL? {
        var components = URLComponents(string: baseURL.url)

        guard let path = path?.name else {
            return nil
        }
        
        components?.path += path

        guard let queries = queries else {
            return nil
        }
        components?.queryItems = queries.map(URLQueryItem.init(name:value:))
        
        return components?.url
    }
}
