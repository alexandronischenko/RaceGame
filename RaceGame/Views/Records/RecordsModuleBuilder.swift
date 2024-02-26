//
//  RecordsModuleBuilder.swift
//  Aston
//
//  Created by Alexandr Onischenko on 08.02.2024.
//

import Foundation

class RecordsBuilder {
    func build() -> RecordsViewController{
        let view = RecordsViewController()
        let presenter = RecordsPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
