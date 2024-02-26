//
//  GamePresenter.swift
//  Aston
//
//  Created by Alexandr Onischenko on 08.02.2024.
//

import Foundation

protocol GamePresenterProtocol {
    init(view: GameViewProtocol)
    func start()
    func stopGame(score: Int)
}

class GamePresenter: GamePresenterProtocol {
    
    unowned let view: GameViewProtocol

    required init(view: GameViewProtocol) {
        self.view = view
    }

    func start() {
        let car = UserDefaults.standard.car
        let carName = Constants.Assets.Cars.allCases[car].rawValue
        let difficult = UserDefaults.standard.difficult
        let obstacle = UserDefaults.standard.obstacle
        let control = UserDefaults.standard.control
        var speed: Double = .zero
        switch difficult {
        case .easy:
            speed = 1
        case .medium:
            speed = 1.5
        case .hard:
            speed = 2
        }
        view.start(car: carName, speed: speed, obstacle: obstacle, control: control)
    }

    func stopGame(score: Int) {
        view.showAlert()
        saveRecord(score: score)
    }

    private func saveRecord(score: Int) {
        if score == .zero { return }

        var records = UserDefaults.standard.records
        let image = UserDefaults.standard.imagePath
        let name = UserDefaults.standard.name

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: Date())

        let newValue = Record(image: image, name: name, score: "\(score)", date: formattedDate)
        records.append(newValue)
        UserDefaults.standard.records = records
    }
}
