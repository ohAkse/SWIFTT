//
//  TableDetailViewRepresentable.swift
//  SWIFTT
//
//  Created by 박유경 on 6/22/24.
//

import UIKit
import SwiftUI

struct TableDetailViewRepresentable: UIViewRepresentable {
    @Binding var bookSearchItem: BookSearchDetailItem?
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView().then {
            $0.dataSource = context.coordinator
            $0.delegate = context.coordinator
            $0.register(SearchDetailViewCell.self, forCellReuseIdentifier: SearchDetailViewCell.identifier.self)
        }
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        DispatchQueue.main.async {
            uiView.reloadData()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: TableDetailViewRepresentable
        
        init(parent: TableDetailViewRepresentable) {
            self.parent = parent
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.bookSearchItem == nil ? 0 : 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailViewCell.identifier, for: indexPath) as? SearchDetailViewCell else {
                return UITableViewCell()
            }
            if let book = parent.bookSearchItem {
                cell.configItem(with: book)
            }
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
