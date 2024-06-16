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

    var body: some View {
        HStack {
            TextField("입력하고자 하는 책 이름을 넣어주세요.", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 10)

            Button(action: {
                onCommit()
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
    }
}
