//
//  Localizable.swift
//  Aston
//
//  Created by Alexandr Onischenko on 25.02.2024.
//

import Foundation

enum Localizable: String, RawRepresentable, LocalizableProtocol {
    // MARK: - Actions

    case back = "back"
    case close = "close"
    case save = "save"

    // MARK: - Settings

    case profile = "profile"
    case chooseCar = "choose_car"
    case chooseDifficult = "choose_difficult"
    case chooseControl = "choose_control"
    case chooseObstacle = "choose_obstacle"
    case saved = "saved"

    // MARK: - Main

    case play = "play"
    case settings = "settings"
    case records = "records"

    // MARK: - Game

    case score = "score"
    case youCrashedIntoCar = "you_crashed_into_car"
    case youHaveEarnedPoints = "you_have_earned_points"

    // MARK: - Obstacle

    case obstacle = "obstacle"
    case tree = "tree"
    case shrub = "shrub"
    case nothing = "nothing"

    // MARK: - Difficult

    case difficult = "difficult"
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"

    // MARK: - Control

    case control = "control"
    case tap = "tap"
    case swipe = "swipe"
    case accelerometer  = "accelerometer"

    // MARK: - Cars

    case car = "car"
    case bluePickup = "blue_pickup"
    case yellowPickup = "yellow_pickup"
    case truck = "truck"
    case longHaulTruck  = "long_haul_truck"

}
