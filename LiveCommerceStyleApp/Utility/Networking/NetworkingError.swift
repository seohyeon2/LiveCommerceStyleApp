//
//  NetworkingError.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import Foundation

enum NetworkingError: Error {
    case invalidHttpResponse
    case noData
    case invalidURL
}
