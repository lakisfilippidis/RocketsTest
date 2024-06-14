//
//  RealmService.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import Foundation
import RealmSwift
import RxSwift

class RealmService {
    private let realm = try! Realm()

    func saveRocket(_ rocket: RocketModel) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(rocket, update: .modified)
                }
            } catch {
                print("Error saving rocket: \(error)")
            }
        }
    }

    func saveRocketViewModel(_ rocketViewModel: RocketViewModel) {
        self.saveRocket(rocketViewModel.toRocketModel())
    }

    func fetchRockets() -> [RocketModel] {
        return Array(realm.objects(RocketModel.self))
    }
}
