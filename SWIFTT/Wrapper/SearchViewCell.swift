//
//  SearchViewCell.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import UIKit

class SearchViewCell: UITableViewCell {
    static let identifier = "SearchCell"
    
    lazy var titleLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        [titleLabel].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with item: SearchItem) {
        titleLabel.text = item.title
    }
}
