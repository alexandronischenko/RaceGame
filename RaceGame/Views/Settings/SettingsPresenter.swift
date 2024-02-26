//
//  SettingsPresenter.swift
//  Aston
//
//  Created by Alexandr Onischenko on 05.02.2024.
//

import Foundation
import UIKit

protocol SettingsViewPresenter {
    var name: String { get }
    var image: UIImage { get }
    var obstacle: Int { get }
    var control: Int { get }
    var difficult: Int { get }
    var obstacleCases: [Obstacle] { get }
    var difficultCases: [Difficult] { get }
    var controlCases: [Control] { get }
    var carColor: UIColor { get }
    var selectedCar: Int { get }
    func reloadData()
    func save(image: UIImage?, name: String?, car: Int, obstacleIndex: Int, difficultIndex: Int, controlIndex: Int)
}

class SettingsPresenter: SettingsViewPresenter {
    weak var view: SettingsView?

    var name: String {
        UserDefaults.standard.name
    }

    var image: UIImage {
        let imageName = UserDefaults.standard.imagePath
        let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent(imageName)
        if let image = UIImage(contentsOfFile: imagePath.path) {
            return image
        }
        return .person()
    }

    var obstacle: Int {
        UserDefaults.standard.obstacle.rawValue
    }

    var difficult: Int {
        UserDefaults.standard.difficult.rawValue
    }

    var control: Int {
        UserDefaults.standard.control.rawValue
    }

    var obstacleCases: [Obstacle] {
        return Obstacle.allCases
    }

    var difficultCases: [Difficult] {
        return Difficult.allCases
    }

    var controlCases: [Control] {
        return Control.allCases
    }

    var carColor: UIColor {
        UserDefaults.standard.carColor ?? .black
    }

    var selectedCar: Int {
        UserDefaults.standard.car
    }

    init(view: SettingsView) {
        self.view = view
    }

    func save(image: UIImage?, name: String?, car: Int, obstacleIndex: Int, difficultIndex: Int, controlIndex: Int) {
        if let image = image {
            let imageName = UUID().uuidString
            let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent(imageName)

            if let jpegData = image.jpegData(compressionQuality: .ulpOfOne) {
                try? jpegData.write(to: imagePath)

            }
            UserDefaults.standard.imagePath = imageName
        }
        guard let obstacle = Obstacle(rawValue: obstacleIndex),
              let difficult = Difficult(rawValue: difficultIndex),
              let control = Control(rawValue: controlIndex),
              let name = name else {
            return
        }
        UserDefaults.standard.name = name
        UserDefaults.standard.car = car
        UserDefaults.standard.obstacle = obstacle
        UserDefaults.standard.difficult = difficult
        UserDefaults.standard.control = control
        view?.updateData()
        view?.showAlert()
    }

    func reloadData() {
        view?.updateData()
    }
}
