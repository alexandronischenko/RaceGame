//
//  CustomButton.swift
//  Aston
//
//  Created by Alexandr Onischenko on 05.02.2024.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    convenience init(title: String, type: UIButton.ButtonType = .system) {
        self.init(type: type)
        let height: CGFloat = CGFloat(Constants.Offset.x4)
        setTitleColor(UIColor.white, for: .normal)
        setTitle(title, for: .normal)
        self.titleLabel?.font = .large()
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        layer.cornerRadius = height / CGFloat(Constants.Offset.x4 / Constants.Offset.x)
        backgroundColor = .systemBlue
    }
}
