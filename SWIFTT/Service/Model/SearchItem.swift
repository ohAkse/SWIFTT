//
//  SearchItem.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import Foundation

//TODO: JSON 타입 모델로 맞출것
struct SearchItem: Hashable {
    var id: UUID = UUID()
    var title: String
}
