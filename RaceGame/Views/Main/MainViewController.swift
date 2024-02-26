//
//  MainViewController.swift
//  Aston
//
//  Created by Alexandr Onischenko on 16.01.2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func goToGame()
    func goToSettings()
    func goToRecords()
}

class MainViewController : UIViewController {

    var presenter: MainPresenterProtocol!

    private lazy var playButton: CustomButton = {
        let button = CustomButton(title: Localizable.play.localized)
        button.addTarget(self, action: #selector(goToGameHandler), for: .touchUpInside)

        return button
    }()

    private lazy var settingsButton: CustomButton = {
        let button = CustomButton(title: Localizable.settings.localized)
        button.addTarget(self, action: #selector(goToSettingsHandler), for: .touchUpInside)
        return button
    }()

    private lazy var recordsButton: CustomButton = {
        let button = CustomButton(title: Localizable.records.localized)
        button.addTarget(self, action: #selector(goToRecordsHandler), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(settingsButton)
        stack.addArrangedSubview(recordsButton)
        stack.spacing = CGFloat(Constants.Offset.x)
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()

    let greetingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureView()
    }

    private func configureView() {
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.center.equalToSuperview()
        }
    }

    @objc private func goToGameHandler() {
        self.presenter.goToGame()
    }

    @objc private func goToSettingsHandler() {
        self.presenter.goToSettings()
    }

    @objc private func goToRecordsHandler() {
        self.presenter.goToRecords()
    }
}

extension MainViewController: MainViewProtocol {
    func goToGame() {
        let gameViewController = GameBuilder().build()
        navigationController?.pushViewController(gameViewController, animated: true)
    }

    func goToSettings() {
        let settingsViewController = SettingsAssembly().build()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    func goToRecords() {
        let recordsViewController = RecordsBuilder().build()
        navigationController?.pushViewController(recordsViewController, animated: true)
    }
}
