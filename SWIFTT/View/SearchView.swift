//
//  SearchView.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI

struct SearchView: View {
    @State private var selectedItem: Book?
    @State private var isNextButtonTapped = false
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    SearchTextField(text: $searchViewModel.searchText, onCommit: {
                        searchViewModel.onTappedSearchButton()
                    })
                }
                Divider()
                if searchViewModel.searchStatus == .success {
                    if let _ = searchViewModel.searchItem {
                        TableViewRepresentable(
                            bookSearchItem: $searchViewModel.searchItem,
                            selectedItem: $selectedItem,
                            isNeededReload: $searchViewModel.isNeededReload,
                            isNextButtonTapped: $isNextButtonTapped,
                            onScrolledToBottom: {
                                searchViewModel.loadNextPage()
                            }
                        )
                    }
                } else if searchViewModel.searchStatus == .fail || searchViewModel.searchItem?.total == "0" {
                    Text("검색 된 책이 없습니다.")
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isNextButtonTapped) {
                if let item = selectedItem {
                    let searchDetailVM = SearchDetailViewModel(networkService: NetworkService(imageService: ImageCacheService())).then {
                        $0.setQueryParam(isbn13: item.isbn13)
                        $0.searchDetailInfo()
                    }
                    SearchDetailView(searchDetailViewModel: searchDetailVM)
                    
                } else {
                    EmptyView()
                }
            }
        }
    }
}


