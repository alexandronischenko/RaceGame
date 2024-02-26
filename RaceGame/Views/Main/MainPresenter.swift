//
//  MainPresenter.swift
//  Aston
//
//  Created by Alexandr Onischenko on 16.01.2024.
//

import Foundation

protocol MainPresenterProtocol{
    func goToSettings()
    func goToGame()
    func goToRecords()
}

class MainPresenter : MainPresenterProtocol {
    weak var view: MainViewProtocol?

    required init(view: MainViewProtocol) {
        self.view = view
    }

    func goToSettings() {
        view?.goToSettings()
    }

    func goToGame() {
        view?.goToGame()
    }

    func goToRecords() {
        view?.goToRecords()
    }

}
