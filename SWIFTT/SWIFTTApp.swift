//
//  SWIFTTApp.swift
//  SWIFTT
//
//  Created by 박유경 on 6/10/24.
//

import SwiftUI

@main
struct SWIFTTApp: App {
    // 아아
    var body: some Scene {
        WindowGroup {
            SearchView(searchViewModel: SearchViewModel(networkService: NetworkService()))
        }
    }
}
