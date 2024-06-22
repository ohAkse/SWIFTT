//
//  Then.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Foundation

protocol Then {}

extension Then where Self: AnyObject {
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension Then where Self: Any {
    func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

extension NSObject: Then {}
extension SearchDetailViewModel: Then {}
extension URLComponents: Then {}
