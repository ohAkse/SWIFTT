//
//  SearchDetailViewModel.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI

class SearchDetailViewModel: ObservableObject {
    deinit {
        Logger.writeLog(.info, message: "SearchDetailViewModel deinit called")
    }
    
    @Published var detailedSearchItem: SearchItem?
    
    init(detailedSearchItem: SearchItem) {
        self.detailedSearchItem = detailedSearchItem
    }
}
