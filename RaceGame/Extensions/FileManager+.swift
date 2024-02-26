//
//  FileManager+extensions.swift
//  Aston
//
//  Created by Alexandr Onischenko on 25.02.2024.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
