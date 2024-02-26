//
//  CarView.swift
//  Aston
//
//  Created by Alexandr Onischenko on 25.02.2024.
//

import Foundation
import UIKit
import SnapKit

class CarView: UIView {
    lazy var car: UIImageView = {
        let view = UIImage()
        let imageView = UIImageView()
        imageView.image = view
        imageView.contentMode = .scaleAspectFit
        imageView.transform = imageView.transform.rotated(by: .pi / 2)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .medium()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(car: UIImage, label: String, frame: CGRect) {
        super.init(frame: frame)

        configure()
        setUpView(car: car, label: label)
    }

    func configure() {
        addSubview(car)
        addSubview(label)

        car.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(Constants.Offset.x4)
        }
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(car.snp.bottom).offset(Constants.Offset.x)
        }
    }

    func setUpView(car: UIImage, label: String) {
        self.car.image = car
        self.label.text = label
    }
}
