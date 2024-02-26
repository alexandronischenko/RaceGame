//
//  GameBuiler.swift
//  Aston
//
//  Created by Alexandr Onischenko on 08.02.2024.
//

import Foundation

class GameBuilder {
    func build() -> GameViewController {
        let view = GameViewController()
        let presenter = GamePresenter(view: view)
        view.presenter = presenter
        return view
    }
}
