//
//  SearchViewCell.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

import UIKit
import SnapKit

class SearchViewCell: UITableViewCell {
    
    private var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private var subtitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    private var priceLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .blue
    }
    
    private var bookImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        [bookImageView, titleLabel, subtitleLabel, priceLabel].forEach { contentView.addSubview($0) }
        
        bookImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(16)
            $0.centerY.equalTo(contentView)
            $0.width.equalTo(50)
            $0.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { 
            $0.leading.equalTo(bookImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(contentView).offset(-16)
            $0.top.equalTo(contentView).offset(8)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(bookImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(contentView).offset(-16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(bookImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(contentView).offset(-16)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            $0.bottom.equalTo(contentView).offset(-8)
        }
    }
    
    func configItem(with book: Book) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        priceLabel.text = book.price
        
        if let url = URL(string: book.image) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.bookImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
