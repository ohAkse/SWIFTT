//
//  SearchView.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI

struct SearchView<Service: NetworkFetchable>: View where Service: NetworkFetchable {
    @State private var searchItems: [SearchItem] = []
    @State private var selectedItem: SearchItem?
    @State private var isNextButtonTapped = false
    @ObservedObject var searchViewModel: SearchViewModel<Service>
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    SearchTextField(text: $searchViewModel.searchText, onCommit: {
                        searchViewModel.onTappedSearchButton()
                    })
                }
                
                Divider()
                
                TableViewRepresentable(searchItem: $searchViewModel.searchItem, selectedItem: $selectedItem, isNeededReload: $searchViewModel.isNeededReload, isNextButtonTapped: $isNextButtonTapped)
            }
            .padding()
            .navigationDestination(isPresented: $isNextButtonTapped) {
                if let item = selectedItem {
                    SearchDetailView(searchDetailViewModel: SearchDetailViewModel(detailedSearchItem: item))
                }
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        return SearchView(searchViewModel: SearchViewModel(networkService: NetworkService()))
    }
}
