//
//  MainAssembly.swift
//  Aston
//
//  Created by Alexandr Onischenko on 16.01.2024.
//

import Foundation

class MainAssembly {
    func build() -> MainViewController{
        let view = MainViewController()
        let presenter = MainPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
