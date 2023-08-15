//
//  Int + extension.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/16.
//

import Foundation

extension Int {
    func getConvertedNumber() -> String {
        if (self / 1000000) > 0 {
            return "\(self / 1000000)M"
        }
        
        if (self / 1000) > 0 {
            return "\(self / 1000)K"
        } else {
            return "\(self)"
        }
    }
}
