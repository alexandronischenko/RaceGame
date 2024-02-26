//
//  SettingsViewController.swift
//  Aston
//
//  Created by Alexandr Onischenko on 05.02.2024.
//

import UIKit

protocol SettingsView: AnyObject {
    func updateData()
    func showAlert()
}

class SettingsViewController: UIViewController {
    var presenter: SettingsViewPresenter!

    fileprivate var items: [UIViewController] = []

    var currentIndex: Int {
        guard let vc = pageController.viewControllers?.first else { return 0 }
        return items.firstIndex(of: vc) ?? 0
    }

    private lazy var picker: UIImagePickerController =  {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()


    private lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.profile.localized
        label.font = .large()
        return label
    }()

    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
        return image
    }()

    private lazy var profileNameTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .right
        field.font = .large()
        field.delegate = self
        return field
    }()

    private lazy var pageController: UIPageViewController = {
        var controller = UIPageViewController()
        return controller
    }()

    private lazy var chooseCarLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.chooseCar.localized
        label.font = .medium()
        return label
    }()

    private lazy var obstacleLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.chooseObstacle.localized
        label.font = .medium()
        return label
    }()

    private lazy var obstacleSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        for (index, obstacle) in presenter.obstacleCases.enumerated() {
            control.insertSegment(withTitle: obstacle.localized, at: index, animated: true)
        }
        control.selectedSegmentIndex = .zero
        return control
    }()

    private lazy var difficultLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.chooseDifficult.localized
        label.font = .medium()
        return label
    }()

    private lazy var difficultSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()

        for (index, difficult) in presenter.difficultCases.enumerated() {
            control.insertSegment(withTitle: difficult.localized, at: index, animated: true)
        }
        return control
    }()

    private lazy var controlLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.chooseControl.localized
        label.font = .medium()
        return label
    }()

    private lazy var controlSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        for (index, control) in presenter.controlCases.enumerated() {
            segmentedControl.insertSegment(withTitle: control.localized, at: index, animated: true)
        }
        return segmentedControl
    }()

    private lazy var saveButton: CustomButton = {
        let button = CustomButton(title: Localizable.save.localized)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Localizable.settings.localized
        view.backgroundColor = .white
        configureView()
        presenter.reloadData()
    }

    private func configureView() {
        view.addSubview(profileLabel)
        view.addSubview(profileImage)
        view.addSubview(profileNameTextField)

        profileLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.top.equalTo(profileLabel.snp.bottom).offset(Constants.Offset.x)
            make.height.width.equalTo(Constants.Offset.x6)
        }
        profileNameTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.leading.equalTo(profileImage.snp.trailing).offset(Constants.Offset.x)
            make.centerY.equalTo(profileImage.snp.centerY)
        }

        view.addSubview(chooseCarLabel)
        chooseCarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.top.equalTo(profileImage.snp.bottom).offset(Constants.Offset.x)
        }

        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [.interPageSpacing: Constants.Offset.x])
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = .systemGray5
        pageController.view.layer.cornerRadius = CGFloat(Constants.Offset.x)

        populateItems()
        let firstViewController = items[presenter.selectedCar]
        pageController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        let containerView = UIView()
        addChild(pageController)
        view.addSubview(containerView)
        containerView.addSubview(pageController.view)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(chooseCarLabel.snp.bottom).offset(Constants.Offset.x)
            make.height.equalTo(Constants.Offset.x8)
        }

        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(obstacleLabel)
        view.addSubview(obstacleSegmentedControl)

        obstacleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(containerView.snp.bottom).offset(Constants.Offset.x)
        }
        obstacleSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(obstacleLabel.snp.bottom).offset(Constants.Offset.x)
        }

        view.addSubview(difficultLabel)
        view.addSubview(difficultSegmentedControl)

        difficultLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(obstacleSegmentedControl.snp.bottom).offset(Constants.Offset.x)
        }
        difficultSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(difficultLabel.snp.bottom).offset(Constants.Offset.x)
        }

        view.addSubview(controlLabel)
        view.addSubview(controlSegmentedControl)

        controlLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(difficultSegmentedControl.snp.bottom).offset(Constants.Offset.x)
        }
        controlSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(controlLabel.snp.bottom).offset(Constants.Offset.x)
        }

        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Offset.x)
            make.trailing.equalToSuperview().inset(Constants.Offset.x)
            make.top.equalTo(controlSegmentedControl.snp.bottom).offset(Constants.Offset.x)
            make.height.equalTo(Constants.Offset.x4)
        }
    }

    @objc func pickImage() {
        present(picker, animated: true)
    }

    @objc func saveButtonPressed() {
        profileNameTextField.resignFirstResponder()
        let image = profileImage.image
        let name = profileNameTextField.text

        let car = currentIndex
        let obstacle = obstacleSegmentedControl.selectedSegmentIndex
        let control = controlSegmentedControl.selectedSegmentIndex
        let difficult = difficultSegmentedControl.selectedSegmentIndex
        presenter.save(image: image,
                       name: name,
                       car: car,
                       obstacleIndex: obstacle,
                       difficultIndex: difficult,
                       controlIndex: control)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileImage.image = image
        dismiss(animated: true)
    }
}

extension SettingsViewController: SettingsView {
    func updateData() {
        profileNameTextField.text = presenter.name
        profileImage.image = presenter.image
        let firstViewController = items[presenter.selectedCar]
        pageController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        obstacleSegmentedControl.selectedSegmentIndex = presenter.obstacle
        controlSegmentedControl.selectedSegmentIndex = presenter.control
        difficultSegmentedControl.selectedSegmentIndex = presenter.difficult
    }

    func showAlert() {
        let alert = UIAlertController()
        alert.title = Localizable.saved.localized
        alert.addAction(UIAlertAction(title: Localizable.close.localized, style: .default, handler: { action in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
}

extension SettingsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    fileprivate func populateItems() {
        for car in Constants.Assets.Cars.allCases {
            let viewController = createCarouselItemControler(car: car)
            items.append(viewController)
        }
    }

    fileprivate func createCarouselItemControler(car: Constants.Assets.Cars) -> UIViewController {
        let viewController = UIViewController()
        let image = UIImage(named: car.rawValue) ?? UIImage()
        let view = CarView()
        view.setUpView(car: image, label: car.localized)
        viewController.view = view
        return viewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return items.last
        }

        guard items.count > previousIndex else { return nil }

        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }

        guard items.count > nextIndex else {
            return nil
        }

        return items[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return items.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageController.viewControllers?.first,
              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }

        return firstViewControllerIndex
    }
}


extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
