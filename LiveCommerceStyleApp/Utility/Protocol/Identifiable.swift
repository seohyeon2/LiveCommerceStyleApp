//
//  Identifiable.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/13.
//

import Foundation

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

extension Identifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
