//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 13.04.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    let coreDataManager = CoreDataManager.shared
    
    private lazy var favoriteTableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .clear
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableview.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        tableview.alwaysBounceVertical = false
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 40
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CORE count: \(coreDataManager.items.count)")
        favoriteTableView.reloadData()
    }
    
    func setupView() {
        title = "Избранное"
        view.backgroundColor = UIColor.gray
        view.addSubview(favoriteTableView)
        NSLayoutConstraint.activate([
            favoriteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

}
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier, for: indexPath) as? FavoriteTableViewCell else {
            let cellDefault = UITableViewCell(style: .default, reuseIdentifier: "default")
            return cellDefault
        }
        let item = coreDataManager.items[indexPath.row]
        cell.favoriteImageView.image = UIImage(named: item.image ?? "COLA")
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let item = coreDataManager.items[indexPath.row]
            coreDataManager.deleteFolder(folder: item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("DELETE")
        @unknown default:
            print("DEFAULT")
        }
    }
}
