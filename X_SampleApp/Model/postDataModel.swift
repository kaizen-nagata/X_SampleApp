//
//  postDataModel.swift
//  X_SampleApp
//
//  Created by r.nagata on 2024/11/26.
//

import Foundation
import RealmSwift

class PostDataModel: Object {
    override static func primaryKey() -> String {
        return "id"
    }
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var username: String = ""
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var content: String = ""
}
