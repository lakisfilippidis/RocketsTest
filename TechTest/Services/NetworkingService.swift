//
//  Networkingservice.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import Foundation
import Alamofire
import RxSwift

private let rocketsUrl = "https://api.spacexdata.com/v4/rockets"
private let launchesUrl = "https://api.spacexdata.com/v4/launches"

class NetworkService {
    func getRockets() -> Observable<[RocketModel]> {
        return Observable.create { observer in
            let request = AF.request(rocketsUrl)
            request.responseDecodable(of: [RocketModel].self) { response in
                switch response.result {
                case .success(let rockets):
                    observer.onNext(rockets)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
