//
//  SearchDetailView.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI

struct SearchDetailView: View {
    
    @StateObject  var searchDetailViewModel: SearchDetailViewModel
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(searchDetailViewModel.detailedSearchItem!.title)
        }
        .padding()
    }
}

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyItem = SearchItem(title: "Dummy Title")
        let viewModel = SearchDetailViewModel(detailedSearchItem: dummyItem)
        return SearchDetailView(searchDetailViewModel: viewModel)
    }
}
