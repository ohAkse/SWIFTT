//
//  SearchTextField.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    var onCommit: () -> Void
    @State private var isNeededCommit = false
    @State private var showAlert = false

    var body: some View {
        HStack {
            TextField("입력하고자 하는 책 이름을 넣어주세요.", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 10)
                .onChange(of: text) { oldValue, newValue in
                    if oldValue != newValue {
                        isNeededCommit = true
                    }
                }

            Button(action: {
                if text.isEmpty {
                    showAlert = true
                } else if isNeededCommit {
                    onCommit()
                    isNeededCommit = false
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("알림"), message: Text("책 이름을 입력해주세요."), dismissButton: .default(Text("확인")))
        }
    }
}

struct ContentView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchTextField(text: $searchText, onCommit: {
                print("Search commit with text: \(searchText)")
            })
        }
    }
}
