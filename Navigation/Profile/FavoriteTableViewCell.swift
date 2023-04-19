//
//  FavoriteTableViewCell.swift
//  Navigation
//
//  Created by Евгений Стафеев on 13.04.2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FavoriteTableViewCell"
    public lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupCell() {
        
        contentView.addSubview(favoriteImageView)
        NSLayoutConstraint.activate([
            favoriteImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            favoriteImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

