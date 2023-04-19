//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    let coreDataManager = CoreDataManager.shared
    var indexSelectedRow: Int?
    
    private lazy var tappingImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "звезда")
        imageView.alpha = 0
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let post: [Post] = Post.makePost()
    let heaferView = ProfileHeaderView()
    var startPointAvatar: CGPoint?
    var cornerRadiusAvatar: CGFloat = 0.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        tableView.register(PhotosTabelViewCell.self, forCellReuseIdentifier: PhotosTabelViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultcell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let profileHeaderView: ProfileHeaderView = {
        let profileHeaderView = ProfileHeaderView()
        profileHeaderView.backgroundColor = .systemGray6
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return profileHeaderView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupLayout()
        
#if DEBUG
        view.backgroundColor = .green
#else
        view.backgroundColor = .red
#endif
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.addSubview(tappingImage)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tappingImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tappingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tappingImage.widthAnchor.constraint(equalToConstant: 300),
            tappingImage.heightAnchor.constraint(equalToConstant: 300),
            
        ])
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        print(#function)
        let touchPoint = sender.location(in: sender.view)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
        self.indexSelectedRow = indexPath.row
        let favoritePostAuth = self.post[self.indexSelectedRow!].author
        let favoritePostImage = self.post[self.indexSelectedRow!].image
        if self.coreDataManager.checkDuplicate(imagePath: favoritePostImage) {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: .allowUserInteraction) {
                self.tappingImage.alpha = 0.8
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.coreDataManager.addNewItem(author: favoritePostAuth, imagePath: favoritePostImage)
                    self.tappingImage.alpha = 0
                }
            }
        } else {
            let alertController = UIAlertController(title: "ВНИМАНИЕ", message: "Данный пост вы уже добавили к себе в избранные", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ОК", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let profileHeader = ProfileHeaderView()
        return section == 0 ? profileHeader : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return section == 0 ? 220 : 0
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTabelViewCell.identifier, for: indexPath) as! PhotosTabelViewCell
            let doubleTapping = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
            doubleTapping.numberOfTapsRequired = 2
            tableView.addGestureRecognizer(doubleTapping)
            doubleTapping.delaysTouchesBegan = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.setupCell(post[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(PhotosViewController(), animated: true)
            self.navigationItem.backButtonTitle = "Back"
        } else { return
        }
    }
}

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

