//
//  RocketDetailViewController.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import Foundation

class RocketDetailViewController: UIViewController {

    var collectionView: UICollectionView!
    var viewModel: RocketViewModel!
    var coordinator: RocketsCoordinator?
    private let disposeBag = DisposeBag()

    init(viewModel: RocketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
    }

    private func setupUI() {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 16.0)
        descriptionTextView.isEditable = false

        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: try! viewModel.imageURL.value()), completed: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameLabel)
        view.addSubview(typeLabel)
        view.addSubview(imageView)
        view.addSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            typeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionTextView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        Observable.combineLatest(viewModel.name, viewModel.type, viewModel.description)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (name, type, description) in
                DispatchQueue.main.async {
                    descriptionTextView.text = description
                    nameLabel.text = name
                    typeLabel.text = type
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editRocketAction))
    }

    @objc private func editRocketAction() {
         coordinator?.showRocketEdit(for: viewModel)
     }
}
