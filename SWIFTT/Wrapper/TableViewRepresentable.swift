//
//  TableViewRepresentable.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import SwiftUI
import UIKit

struct TableViewRepresentable: UIViewRepresentable {
    @Binding var searchItem: [SearchItem]
    @Binding var selectedItem: SearchItem?
    @Binding var isNeededReload: Bool
    @Binding var isNextButtonTapped: Bool

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView().then {
            $0.dataSource = context.coordinator
            $0.delegate = context.coordinator
            $0.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.identifier)
        }
        return tableView
    }
    //MARK: 왜 GCD main에서 업데이트를 해줘야만 하는걸까..
    func updateUIView(_ uiView: UITableView, context: Context) {
        if isNeededReload {
            DispatchQueue.main.async {
                uiView.reloadData()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: TableViewRepresentable

        init(parent: TableViewRepresentable) {
            self.parent = parent
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.searchItem.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier, for: indexPath) as? SearchViewCell else {
                return UITableViewCell()
            }
            let item = parent.searchItem[indexPath.row]
            cell.configure(with: item)
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            parent.selectedItem = parent.searchItem[indexPath.row]
            parent.isNextButtonTapped = true
            tableView.deselectRow(at: indexPath, animated: true)
            Logger.writeLog(.info, message: "SelectedItem -> \(parent.searchItem[indexPath.row].title)")
        }
    }
}
