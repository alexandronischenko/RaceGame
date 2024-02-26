//
//  Font+.swift
//  Aston
//
//  Created by Alexandr Onischenko on 26.02.2024.
//

import Foundation
import UIKit

extension UIFont {
    static func medium() -> UIFont {
        .systemFont(ofSize: 16, weight: .medium)
    }

    static func large() -> UIFont {
        .systemFont(ofSize: 20, weight: .medium)
    }

    static func score() -> UIFont {
        .systemFont(ofSize: 40, weight: .medium)
    }
}
