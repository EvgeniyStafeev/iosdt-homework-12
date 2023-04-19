//
//  UserRealmData.swift
//  Navigation
//
//  Created by Евгений Стафеев on 10.04.2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var categoryName = ""
    dynamic var users = List<NewUsers>()
    override static func primaryKey() -> String? {
        return "id"
    }
}

class NewUsers: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
}
