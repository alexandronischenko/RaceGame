//
//  LocalizableProtocol.swift
//  Aston
//
//  Created by Alexandr Onischenko on 26.02.2024.
//

import Foundation

protocol LocalizableProtocol { }

extension LocalizableProtocol where Self: RawRepresentable  {
    var localized: String {
        return NSLocalizedString("\(self.rawValue)", comment: "")
    }
}
