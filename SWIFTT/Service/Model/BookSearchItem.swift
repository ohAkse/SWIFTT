//
//  SearchItem.swift
//  SWIFTT
//
//  Created by 박유경 on 6/16/24.
//

struct BookSearchItem: Codable {
    let error: String
    let total: String
    let page: String
    var books: [Book]
}

struct Book: Codable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
