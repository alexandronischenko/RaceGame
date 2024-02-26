//
//  RecordsPresenter.swift
//  Aston
//
//  Created by Alexandr Onischenko on 08.02.2024.
//

import Foundation

protocol RecordsPresenterProtocol {
    init(view: RecordsViewProtocol)
    var data: [Record] { get }
    func reloadData()
}

class RecordsPresenter: RecordsPresenterProtocol {
    unowned let view: RecordsViewProtocol

    var data: [Record] = []

    required init(view: RecordsViewProtocol) {
        self.view = view
    }

    func reloadData() {
        data = UserDefaults.standard.records
        data.sort { Int($0.score) ?? .zero > Int($1.score) ?? .zero}
        view.reloadData(data: data)
    }
}
