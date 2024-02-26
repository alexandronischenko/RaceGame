//
//  UserDefaults+extension.swift
//  Aston
//
//  Created by Alexandr Onischenko on 09.02.2024.
//

import Foundation
import UIKit

extension UserDefaults {
    struct Key {
        static let carColor = "carColor"
        static let car = "car"
        static let image = "image"
        static let name = "name"
        static let obstacle = "obstacle"
        static let control = "control"
        static let difficult = "difficult"
        static let records = "records"
    }

    var carColor: UIColor? {
        get { colorForKey(key: Key.carColor) }
        set { setColor(color: newValue, forKey: Key.carColor) }
    }

    var car: Int {
        get {
            if let val = value(forKey: Key.car) {
                return val as! Int
            } else {
                set(0, forKey: Key.car)
                return 0
            }
        }
        set { set(newValue, forKey: Key.car) }
    }

    var imagePath: String {
        get {
            if let val = value(String.self, forKey: Key.image) {
                return val
            } else {
                return ""
            }
        }
        set { set(newValue, forKey: Key.image) }
    }

    var name: String {
        get {
            if let val = value(String.self, forKey: Key.name) {
                return val
            } else {
                set("New user", forKey: Key.name)
                return "New user"
            }
        }
        set { set(newValue, forKey: Key.name) }
    }

    var obstacle: Obstacle {
        get {
            if let val = value(Obstacle.self, forKey: Key.obstacle) {
                return val
            } else {
                set(Obstacle.nothing, forKey: Key.obstacle)
                return Obstacle.nothing
            }
        }
        set { set(newValue, forKey: Key.obstacle) }
    }

    var difficult: Difficult {
        get {
            if let val = value(Difficult.self, forKey: Key.difficult) {
                return val
            } else {
                set(Difficult.medium, forKey: Key.difficult)
                return Difficult.medium
            }
        }
        set { set(newValue, forKey: Key.difficult) }
    }

    var control: Control {
        get {
            if let val = value(Control.self, forKey: Key.control) {
                return val
            } else {
                set(Control.swipe, forKey: Key.control)
                return Control.swipe
            }
        }
        set { set(newValue, forKey: Key.control) }
    }

    var records: [Record] {
        get {
            if let val = value([Record].self, forKey: Key.records) {
                return val
            } else {
                return []
            }
        }
        set { set(newValue, forKey: Key.records) }
    }

    func set<T: Encodable>(_ encodable: T, forKey: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            setValue(data, forKey: forKey)
        }
    }

    func value<T: Decodable>(_ type: T.Type, forKey: String) -> T? {
        if let data = object(forKey: forKey) as? Data,
           let result = try? JSONDecoder().decode(type, from: data) {
            return result
        }
        return nil
    }

    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
            }
        }
        return colorReturnded
    }

    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error UserDefaults")
            }
        }
        set(colorData, forKey: key)
    }
}
