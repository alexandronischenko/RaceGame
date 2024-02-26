//
//  SettingsDara.swift
//  Aston
//
//  Created by Alexandr Onischenko on 20.02.2024.
//

import Foundation
import UIKit

enum Obstacle: Int, CaseIterable, Codable, RawRepresentable {
    case tree
    case shrub
    case nothing

    var localized: String {
        return NSLocalizedString("\(self)", comment: "")
    }
}

enum Difficult: Int, CaseIterable, Codable, RawRepresentable {
    case easy
    case medium
    case hard

    var localized: String {
        return NSLocalizedString("\(self)", comment: "")
    }
}

enum Control: Int, CaseIterable, Codable, RawRepresentable {
    case tap
    case swipe
    case accelerometer

    var localized: String {
        return NSLocalizedString("\(self)", comment: "")
    }
}
