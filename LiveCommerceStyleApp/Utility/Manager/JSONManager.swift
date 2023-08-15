//
//  JSONManager.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import Foundation

enum JSONDecodeError: Error {
    case decodingError
}

final class JSONManager {
    static let shared = JSONManager()
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func decode<T: Decodable>(type: T.Type, from data: Data) -> T? {
        do {
            let returnData = try self.decoder.decode(T.self, from: data)
            return returnData
        } catch {
            return nil
        }
    }
}
