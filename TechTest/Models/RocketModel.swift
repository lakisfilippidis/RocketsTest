//
//  RocketModel.swift
//  TechTest
//
//  Created by Lakis Filippidis on 12/06/24.
//

import Foundation
import RealmSwift

open class RocketModel: Object, Codable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var type: String
    @Persisted var descriptionText: String
    @Persisted var wikipedia: String
    @Persisted var flickrImages: List<String>

    public override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case wikipedia
        case descriptionText = "description"
        case flickrImages = "flickr_images"
    }
}
