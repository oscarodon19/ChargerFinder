//
//  CustomTableViewCell.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 23/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    private let titleText: String
    private let detailText: String
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(assetIdentifier: .chargerIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.textColor = UIColor.appColor(.title)
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = detailText
        label.textColor = UIColor.appColor(.title)
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, detail: String, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleText = title
        detailText = detail
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.Error.initNotImplemented)
    }
}

extension CustomTableViewCell {
    func setupView() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 0.84),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -3),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 13),
            detailLabel.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 2),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        ])
    }
}
