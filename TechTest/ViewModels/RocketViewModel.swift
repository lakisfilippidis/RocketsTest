//
//  RocketViewModel.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import Foundation
import RxSwift
import RxCocoa
import Realm

class RocketViewModel {
    private let disposeBag = DisposeBag()
    private let networkService: NetworkService
    private let realmService: RealmService
    
    let id: String
    let wikipedia: String
    var name: BehaviorSubject<String>
    var type: BehaviorSubject<String>
    var description: BehaviorSubject<String>
    var imageURL: BehaviorSubject<String>

    init(rocket: RocketModel, networkService: NetworkService, realmService: RealmService) {
        self.id = rocket.id
        self.wikipedia = rocket.wikipedia
        self.name = BehaviorSubject(value: rocket.name)
        self.type = BehaviorSubject(value: rocket.type)
        self.description = BehaviorSubject(value: rocket.descriptionText)
        self.imageURL = BehaviorSubject(value: rocket.flickrImages.first ?? "")

        self.networkService = networkService
        self.realmService = realmService
    }

    func saveChanges() {
        realmService.saveRocketViewModel(self)
    }
}

extension RocketViewModel {
    func toRocketModel() -> RocketModel {
        let rocketModel = RocketModel()
        rocketModel.id = self.id

        do {
            rocketModel.name = try self.name.value()
            rocketModel.type = try self.type.value()
            rocketModel.descriptionText = try self.description.value()
            rocketModel.flickrImages.removeAll()
            rocketModel.flickrImages.append(try self.imageURL.value())
        } catch {
            print("Error transforming view models text value: \(error)")
        }

        return rocketModel
    }
}
