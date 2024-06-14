//
//  RocketsCoordinator.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import Foundation 
import UIKit
import RxSwift
import RxCocoa

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class RocketsCoordinator: Coordinator {
    let realmService = RealmService()
    let networkService = NetworkService()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let rocketsViewModel = RocketsViewModel(networkService: networkService, realmService: realmService)
        let rocketsViewController = RocketsViewController(viewModel: rocketsViewModel)
        rocketsViewController.coordinator = self
        navigationController.pushViewController(rocketsViewController, animated: true)
    }

    func showRocketDetail(for rocket: RocketViewModel) {
        let rocketDetailViewController = RocketDetailViewController(viewModel: rocket)
        rocketDetailViewController.coordinator = self
        navigationController.pushViewController(rocketDetailViewController, animated: true)
    }

    func showRocketEdit(for rocket: RocketViewModel) {
        let rocketEditViewController = RocketEditViewController(viewModel: rocket)
        rocketEditViewController.coordinator = self
        navigationController.pushViewController(rocketEditViewController, animated: true)
    }
}
