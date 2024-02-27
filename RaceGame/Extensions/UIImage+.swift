//
//  UIImage+.swift
//  Aston
//
//  Created by Alexandr Onischenko on 26.02.2024.
//

import Foundation
import UIKit

extension UIImage {
    static func person() -> UIImage {
        UIImage(systemName: "person.badge.plus") ?? UIImage()
    }

    static func left() -> UIImage {
        UIImage(systemName: "arrowtriangle.left.fill") ?? UIImage()
    }

    static func right() -> UIImage {
        UIImage(systemName: "arrowtriangle.right.fill") ?? UIImage()
    }
}


