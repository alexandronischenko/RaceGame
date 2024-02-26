//
//  SettingsAssembly.swift
//  Aston
//
//  Created by Alexandr Onischenko on 05.02.2024.
//

import Foundation

class SettingsAssembly {
    func build() -> SettingsViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
