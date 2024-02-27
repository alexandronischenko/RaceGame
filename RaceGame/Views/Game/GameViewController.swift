//
//  ViewController.swift
//  Aston
//
//  Created by Alexandr Onischenko on 11.01.2024.
//

import UIKit
import SnapKit
import CoreMotion

protocol GameViewProtocol: AnyObject {
    func start(car: String, speed: Double, obstacle: Obstacle, control: Control)
    func showAlert()
}

class GameViewController: UIViewController {
    var presenter: GamePresenterProtocol!

    private lazy var road: UIImageView = {
        let view = UIImage(named: Constants.Assets.road1)!
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = view
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var car: UIImageView = {
        let view = UIImage(named: Constants.Assets.Cars.allCases[.zero].rawValue)!
        let imageView = UIImageView(image: view)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private lazy var carObstacles: [UIImageView] = {
        var views = [UIImageView]()
        for car in Constants.Assets.Cars.allCases {
            let imageView = UIImageView(image: UIImage(named: car.rawValue))
            imageView.contentMode = .scaleAspectFit
            views.append(imageView)
        }
        return views
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .score()
        label.textAlignment = .center
        return label
    }()

    private lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        let leftImage = UIImage.left()
        leftButton.setImage(leftImage, for: .normal)
        leftButton.sizeToFit()
        leftButton.tag = 0
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.contentVerticalAlignment = .fill
        leftButton.contentHorizontalAlignment = .fill
        leftButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
        leftButton.isEnabled = false
        return leftButton
    }()

    private lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        let rightImage = UIImage.right()
        rightButton.setImage(rightImage, for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.contentVerticalAlignment = .fill
        rightButton.contentHorizontalAlignment = .fill
        rightButton.tag = 1
        rightButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
        rightButton.isEnabled = false
        return rightButton
    }()


    private lazy var score: Int = .zero {
        didSet {
            scoreLabel.text = "\(Localizable.score.localized): \(score)"
        }
    }

    private lazy var gameTimer: Timer = {
        return Timer()
    }()

    private lazy var buttonTimer: Timer = {
        return Timer()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        gameTimer.invalidate()
    }

    private func configureView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true

        view.insertSubview(road, at: .zero)
        view.addSubview(scoreLabel)
        road.addSubview(car)

        scoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        car.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.Offset.carOffset)
        }

        road.addSubview(leftButton)
        road.addSubview(rightButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Offset.x2)
            make.height.width.equalTo(Constants.Offset.x6)
        }
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.Offset.x2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Offset.x2)
            make.height.width.equalTo(Constants.Offset.x6)
        }

        var nextCarSpawnPoint: Int = .zero
        for carObstacle in carObstacles {
            road.addSubview(carObstacle)
            carObstacle.snp.makeConstraints { make in
                let random = Int.random(in: Constants.Game.leftBorder ..< Constants.Game.rightBorder)
                make.centerX.equalToSuperview().offset(random)
                make.centerY.equalToSuperview().offset(-Constants.Game.spawnPointY - nextCarSpawnPoint)
            }
            nextCarSpawnPoint += Constants.Game.spawnDelay
        }
    }

    @objc func handleSwipe(_ sender: UIPanGestureRecognizer? = nil) {
        if let view = sender?.view,
           let translation = sender?.translation(in: self.view) {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y)
        }
        sender?.setTranslation(CGPointZero, in: self.view)
    }

    // MARK: TAP CONTROL
    private lazy var x: Int = .zero

    @objc func buttonUp(_ sender: UIButton? = nil) {
        buttonTimer.invalidate()
        x = .zero
    }

    @objc func buttonDown(_ sender: UIButton? = nil) {
        switch sender?.tag {
        case 0:
            x = -Constants.Game.unit
        case 1:
            x = Constants.Game.unit
        default:
            x = .zero
        }
        buttonTimer = Timer.scheduledTimer(timeInterval: Constants.Game.timeInterval, target: self, selector: #selector(move), userInfo: nil, repeats: true)
    }

    @objc func move() {
        car.center = CGPoint(x: self.car.center.x + CGFloat(x) ,
                             y: self.car.center.y)
    }

    //MARK: ACCELEROMETER CONTROL
    let motion = CMMotionManager()
    func startAccelerometers() {
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = Constants.Game.timeInterval
            self.motion.startAccelerometerUpdates()

            self.gameTimer = Timer(fire: Date(), interval: Constants.Game.timeInterval,
                               repeats: true, block: { (timer) in
                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x

                    self.car.center = CGPoint(x: self.car.center.x + x, y: self.car.center.y)
                }
            })

            RunLoop.current.add(self.gameTimer, forMode: RunLoop.Mode.default)
        }
    }

    @objc func startTimer() {
        gameTimer.fire()
    }

    func stop() {
        gameTimer.invalidate()
        buttonTimer.invalidate()
        self.car.isUserInteractionEnabled = false
        self.road.isUserInteractionEnabled = false
        enableButtons(bool: false)
        presenter.stopGame(score: score)
    }
}

extension GameViewController: GameViewProtocol {
    func start(car: String, speed: Double, obstacle: Obstacle, control: Control) {
        score = .zero
        self.car.image = UIImage(named: car)

        configure(obstacle: obstacle)
        configure(control: control)

        let group = DispatchGroup()
        let obstacleMovement = DispatchWorkItem {
            self.gameTimer = Timer.scheduledTimer(withTimeInterval: Constants.Game.timeInterval, repeats: true) { timer in
                guard let car = self.car.layer.presentation()?.frame else { return }
                self.score += Constants.Game.unit
                for carObstacle in self.carObstacles {
                    guard let carObstacleFrame = carObstacle.layer.presentation()?.frame else { return }
                    if (CGRectIntersectsRect(car, carObstacleFrame)) {
                        self.stop()
                    }

                    if carObstacle.center.y - Constants.Game.advanceDistance < self.car.center.y {
                        carObstacle.center = CGPoint(x: carObstacle.center.x,
                                                     y: carObstacle.center.y + speed)
                    } else {
                        let random = Int.random(in: Constants.Game.leftBorder ..< Constants.Game.rightBorder)
                        carObstacle.center = CGPoint(x:
                                                        self.view.center.x + CGFloat(random),
                                                     y: (self.view.center.y - Constants.Game.advanceDistance))
                    }
                }
            }
        }
        configureView()

        DispatchQueue.main.async(group: group, execute: obstacleMovement)
    }

    func showAlert() {
        let alert = UIAlertController()
        alert.title = Localizable.youCrashedIntoCar.localized
        alert.message = "\(Localizable.youHaveEarnedPoints.localized): \(score)"
        alert.addAction(UIAlertAction(title: Localizable.close.localized, style: .default, handler: { action in
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    private func configure(obstacle: Obstacle) {
        switch obstacle {
        case .tree:
            let imageView = UIImageView(image: UIImage(named: Constants.Assets.tree))
            imageView.contentMode = .scaleAspectFit
            self.carObstacles.append(imageView)
        case .shrub:
            let imageView = UIImageView(image: UIImage(named: Constants.Assets.shrub))
            imageView.contentMode = .scaleAspectFit
            self.carObstacles.append(imageView)
        case .nothing:
            break
        }
    }

    private func configure(control: Control) {
        switch control {
        case .tap:
            enableButtons(bool: true)
        case .swipe:
            enableButtons(bool: false)
            let swipe = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
            self.car.addGestureRecognizer(swipe)
        case .accelerometer:
            enableButtons(bool: false)
            startAccelerometers()
        }
    }

    private func enableButtons(bool: Bool) {
        leftButton.isHidden = !bool
        rightButton.isHidden = !bool
        leftButton.isEnabled = bool
        rightButton.isEnabled = bool
    }
}

