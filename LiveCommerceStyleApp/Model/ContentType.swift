//
//  ContentType.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import Foundation

enum ContentType {
    case image
    case video
    var name: String {
        switch self {
        case .image:
            return "image"
        case .video:
            return "video"
        }
    }
}
