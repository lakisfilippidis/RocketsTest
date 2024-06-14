//
//  RocketsCollectionCell.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import UIKit
import SDWebImage
import Foundation
import RxSwift

class RocketCollectionViewCell: UICollectionViewCell {
    static let identifier = "RocketCollectionViewCell"
    private var disposeBag = DisposeBag()

    private let rocketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(rocketImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(descriptionLabel)

        rocketImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.numberOfLines = 2
        typeLabel.numberOfLines = 1

        NSLayoutConstraint.activate([
            rocketImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rocketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rocketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rocketImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),

            nameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            nameLabel.topAnchor.constraint(equalTo: rocketImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            typeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rocket: RocketViewModel) {
        rocket.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)

        rocket.type
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)

        rocket.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        do {
            if let imageUrl = URL(string: try rocket.imageURL.value()) {
                rocketImageView.sd_setImage(with: imageUrl, completed: nil)
            }
        } catch {
            print("Error transforming view models text value: \(error)")
        }
    }
}
