//
//  APIComponents.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/08.
//

import Foundation

enum BaseURL: String {
    case dev
    
    var url: String {
        switch self {
        case .dev:
            return "https://0fjrekl8p0.execute-api.ap-northeast-1.amazonaws.com/dev"
        }
    }
}

enum Path: String {
    case posts
    
    var name: String {
        switch self {
        case .posts:
            return "/posts"
        }
    }
}

enum HTTPMethod: String {
    case get
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
