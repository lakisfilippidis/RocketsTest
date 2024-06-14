//
//  RocketsViewController.swift
//  TechTest
//
//  Created by Lakis Filippidis on 11/06/24.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class RocketsViewController: UIViewController {

    var collectionView: UICollectionView!
    var viewModel: RocketsViewModel!
    var coordinator: RocketsCoordinator?
    private let disposeBag = DisposeBag()

    init(viewModel: RocketsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.bounds.width / 2.5
        let height = width * 2

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(RocketCollectionViewCell.self, forCellWithReuseIdentifier: RocketCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        bindCollectionView()
        viewModel.fetchRockets()
    }

    private func bindCollectionView() {
        viewModel.rockets
            .bind(to: collectionView.rx.items(cellIdentifier: RocketCollectionViewCell.identifier, cellType: RocketCollectionViewCell.self)) { row, rocket, cell in
                cell.configure(with: rocket)
            }
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(RocketViewModel.self)
            .subscribe(onNext: { [weak self] rocketViewModel in
                self?.coordinator?.showRocketDetail(for: rocketViewModel)
            })
            .disposed(by: disposeBag)

        viewModel.error
            .subscribe(onNext: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
