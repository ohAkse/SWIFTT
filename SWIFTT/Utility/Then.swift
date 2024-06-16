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

extension NSObject: Then {}
