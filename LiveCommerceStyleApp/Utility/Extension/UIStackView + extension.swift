//
//  UIStackView + extension.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/16.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubview() {
        self.arrangedSubviews.forEach({ child in
            self.removeArrangedSubview(child)
            child.removeFromSuperview()
        })
    }
}
