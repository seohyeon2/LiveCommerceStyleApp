//
//  Observable.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

final class Observable<T> {
    typealias Listener = (T) -> Void

    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
