//
//  RocketsViewModel.swift
//  TechTest
//
//  Created by Lakis Filippidis on 11/06/24.
//

import Foundation
import RxSwift
import RxCocoa

class RocketsViewModel {
    private let networkService: NetworkService
    private let realmService: RealmService

    let rockets: BehaviorRelay<[RocketViewModel]> = BehaviorRelay(value: [])
    let error: PublishSubject<Error> = PublishSubject()

    private let disposeBag = DisposeBag()

    init(networkService: NetworkService, realmService: RealmService) {
        self.networkService = networkService
        self.realmService = realmService
    }

    func fetchRockets() {
        let rocketViewModel = realmService.fetchRockets().map { RocketViewModel(rocket: $0, networkService: networkService, realmService: realmService) }
        rockets.accept(rocketViewModel)
        if rockets.value.count > 1 {
            return
        }

        networkService.getRockets()
            .observe(on: MainScheduler.instance)
            .map { rockets in
                return rockets.map { RocketViewModel(rocket: $0, networkService: self.networkService, realmService: self.realmService) }
            }
            .subscribe(onNext: { [weak self] rocketViewModels in
                self?.rockets.accept(rocketViewModels)

                for rocketViewModel in rocketViewModels {
                    self?.realmService.saveRocket(rocketViewModel.toRocketModel())
                }
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
