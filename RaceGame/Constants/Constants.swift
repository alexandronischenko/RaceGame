//
//  Constants.swift
//  Aston
//
//  Created by Alexandr Onischenko on 24.02.2024.
//

import Foundation

struct Constants {
    struct Assets {
        static let road = "road"
        static let road1 = "road-1"
        static let tree = "tree"
        static let shrub = "shrub"

        enum Cars: String, CaseIterable, LocalizableProtocol {
            case car = "car"
            case bluePickup = "blue_pickup"
            case yellowPickup = "yellow_pickup"
            case truck = "truck"
            case longHaulTruck = "long_haul_truck"
        }
    }

    struct Offset {
        static let x = 16
        static let x2 = 32
        static let x4 = 64
        static let x6 = 96
        static let x8 = 128
        static let carOffset = 256
    }

    struct Game {
        static let leftBorder = -100
        static let rightBorder = 100
        static let advanceDistance: CGFloat = 500
        static let spawnDelay = 250
        static let spawnPointY = 600
        static let timeInterval = 1.0 / 50.0
        static let unit = 1
    }
}
