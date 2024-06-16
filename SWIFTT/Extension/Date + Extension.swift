//
//  Date + Extension.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Foundation

extension Date {    
    func getCurrentTime() -> String {
        let formatter = DateFormatter().then {
            $0.dateFormat = "a h:mm"
            $0.amSymbol = "오전"
            $0.pmSymbol = "오후"
        }
        let dateString = formatter.string(from: self)
        return dateString
    }
}
