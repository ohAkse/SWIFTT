//
//  SearchDetailViewCell.swift
//  SWIFTT
//
//  Created by 박유경 on 6/22/24.
//

import UIKit

class SearchDetailViewCell: UITableViewCell {
    
    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.numberOfLines = 0
    }
    
    private let authorsLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private let publisherLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    private let languageLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    private let isbnLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    private let pagesLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let yearLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let ratingLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .systemYellow
    }
    
    private let descLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private let priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .systemGreen
    }
    
    private let urlLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .blue
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        let labelsStackView = UIStackView(arrangedSubviews: [
            titleLabel, subtitleLabel, authorsLabel, publisherLabel,
            languageLabel, isbnLabel, pagesLabel, yearLabel, ratingLabel,
            descLabel, priceLabel, urlLabel]).then {
            $0.axis = .vertical
            $0.spacing = 8}

        
        [bookImageView, labelsStackView].forEach { contentView.addSubview($0) }
        
        bookImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        labelsStackView.snp.makeConstraints {
            $0.leading.equalTo(bookImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configItem(with book: BookSearchDetailItem) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        authorsLabel.text = "Authors: \(book.authors)"
        publisherLabel.text = "Publisher: \(book.publisher)"
        languageLabel.text = "Language: \(book.language)"
        isbnLabel.text = "ISBN-10: \(book.isbn10), ISBN-13: \(book.isbn13)"
        pagesLabel.text = "Pages: \(book.pages)"
        yearLabel.text = "Year: \(book.year)"
        ratingLabel.text = "Rating: \(book.rating)"
        descLabel.text = book.desc
        priceLabel.text = "Price: \(book.price)"
        urlLabel.text = book.url
  
        
        if let cachedImage = ImageCacheService.shared.getCachedImage(for: book.image) {
            bookImageView.image = cachedImage
        }
    }
}
