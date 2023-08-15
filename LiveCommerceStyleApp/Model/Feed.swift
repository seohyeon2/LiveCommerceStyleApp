//
//  Feed.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/08.
//

import Foundation

struct Feed: Decodable {
    let count: Int
    let page: Int
    let posts: [Post]
}

struct Post: Decodable {
    let contents: [Content]
    let description: String
    let id: String
    let influencer: Influencer
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case contents, description, id, influencer
        case likeCount = "like_count"
    }
}

struct Content: Decodable {
    let contentURL: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case contentURL = "content_url"
        case type
    }
}

struct Influencer: Decodable {
    let displayName: String
    let followCount: Int
    let profileThumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case followCount = "follow_count"
        case profileThumbnailURL = "profile_thumbnail_url"
    }
}
