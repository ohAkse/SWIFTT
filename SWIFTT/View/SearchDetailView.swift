//
//  SearchDetailView.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI

struct SearchDetailView: View {
    
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    var body: some View {
        VStack {
            if searchDetailViewModel.searchStatus == .success {
                if let _ = searchDetailViewModel.searchDetailItem {
                    TableDetailViewRepresentable(bookSearchItem: $searchDetailViewModel.searchDetailItem)
                }
            }
        }
        .padding()
    }
}


