//
//  CoreDataService.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import Foundation
import CoreData
import RxSwift
import UIKit

class CoreDataService {
    static let shared = CoreDataService()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveRockets(_ rockets: [RocketModel]) {
        rockets.forEach { rocket in
            let entity = RocketEntity(context: context)
            entity.id = rocket.id
            entity.name = rocket.name
            entity.type = rocket.type
        }
        saveContext()
    }

    func fetchRockets() -> Observable<[RocketEntity]> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<RocketEntity> = RocketEntity.fetchRequest()

            do {
                let rockets = try self.context.fetch(fetchRequest)
                observer.onNext(rockets)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
