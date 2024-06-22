//
//  TableViewRepresentable.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI
import UIKit

struct TableViewRepresentable: UIViewRepresentable {
    @Binding var bookSearchItem: BookSearchItem?
    @Binding var selectedItem: Book?
    @Binding var isNeededReload: Bool
    @Binding var isTappedCell: Bool
    
    var onScrolledToBottom: (() -> Void)?

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView().then {
            $0.configure(dataSource: context.coordinator, delegate: context.coordinator, cellType: SearchViewCell.self)
        }
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        if isNeededReload && bookSearchItem != nil{
            DispatchQueue.main.async {
                uiView.reloadData()
                self.isNeededReload = false 
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: TableViewRepresentable
        var isFetching = false
        
        init(parent: TableViewRepresentable) {
            self.parent = parent
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.bookSearchItem?.books.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier, for: indexPath) as? SearchViewCell else {
                return UITableViewCell()
            }
            let book = parent.bookSearchItem!.books[indexPath.row]
            cell.configItem(with: book)
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            parent.selectedItem = parent.bookSearchItem!.books[indexPath.row]
            parent.isTappedCell = true
            tableView.deselectRow(at: indexPath, animated: true)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > contentHeight - height * 2, !isFetching {
                isFetching = true
                parent.onScrolledToBottom?()
            }
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            isFetching = false
        }
    }
}
