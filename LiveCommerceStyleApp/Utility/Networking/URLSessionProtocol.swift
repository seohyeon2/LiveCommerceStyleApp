//
//  URLSessionProtocol.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/16.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol { }
