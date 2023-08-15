//
//  ShopRequest.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import Foundation

struct ShopRequest: APIRequest {
    var baseURL: BaseURL
    var method: HTTPMethod
    var path: Path?
    var queries: [String : String]?
}
