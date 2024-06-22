//
//  UITableView + Extension.swift
//  SWIFTT
//
//  Created by 박유경 on 6/22/24.
//

import UIKit

extension UITableView {
    func configure<T: UITableViewCell>(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, cellType: T.Type) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.register(cellType, forCellReuseIdentifier: T.identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
