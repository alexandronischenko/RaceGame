//
//  RecordsViewController.swift
//  Aston
//
//  Created by Alexandr Onischenko on 08.02.2024.
//

import UIKit

protocol RecordsViewProtocol: AnyObject {
    func reloadData(data: [Record])
}

class RecordsViewController: UIViewController {
    var presenter: RecordsPresenterProtocol!
    
    var data: [Record] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        presenter.reloadData()
    }

    func configureView() {
        title = Localizable.records.localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        tableView = UITableView(frame: .zero)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        
        let record = presenter.data[indexPath.row]

        let imageName = record.image
        let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent(imageName)
        guard let image = UIImage(contentsOfFile: imagePath.path) else { return UITableViewCell() }

        var content = UIListContentConfiguration.sidebarCell()
        content.textProperties.font = .large()
        content.imageProperties.maximumSize = CGSize(width: 64, height: 64)
        content.imageToTextPadding = 16
        content.imageProperties.cornerRadius = 4
        content.secondaryTextProperties.font = .systemFont(ofSize: 18, weight: .light)

        content.image = image
        content.secondaryText = record.date
        content.text = "\(record.score) - \(record.name)"
        cell.contentConfiguration = content

        return cell
    }
}

extension RecordsViewController: RecordsViewProtocol {
    func reloadData(data: [Record]) {
        self.data = data
        tableView.reloadData()
    }
}
