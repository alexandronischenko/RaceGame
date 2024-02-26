//
//  Record.swift
//  Aston
//
//  Created by Alexandr Onischenko on 24.02.2024.
//

import Foundation

class Record: Codable {
    var image: String
    var name: String
    var score: String
    var date: String

    init(image: String, name: String, score: String, date: String) {
        self.image = image
        self.name = name
        self.score = score
        self.date = date
    }
}
