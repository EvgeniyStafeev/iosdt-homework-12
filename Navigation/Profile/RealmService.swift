//
//  RealmService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 09.04.2023.
//

import Foundation
import RealmSwift

class RealmService {
    let realm = try! Realm()
    
    func createCategory(name: String) {
        let category = Category()
        category.categoryName = name
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("ERROR: \(error)")
        }
        
    }
   
    func addUser(categoryId: String, user: NewUsers) {
        guard let category = realm.object(ofType: Category.self, forPrimaryKey: categoryId) else { return }
        do {
            try realm.write({
                category.users.append(user)
            })
        } catch {
            print("ERROR: \(error)")
        }
    }
    
   
    func deleteAllCategory() {
        do {
        try realm.write({
            _ = realm.objects(Category.self)
            realm.deleteAll()
        })
        } catch {
            print("ERROR: \(error)")
        }
    }
    
}
