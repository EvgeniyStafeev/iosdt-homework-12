//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Евгений Стафеев on 13.04.2023.
//

import CoreData

class CoreDataManager {
    var items: [FavoriteItem] = []
    static let shared = CoreDataManager()
    private init() {
        reloadFolders()
    }
   
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Navigation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func reloadFolders() {
        do {
            let items = try persistentContainer.viewContext.fetch(FavoriteItem.fetchRequest()) as! [FavoriteItem]
            self.items = items
        } catch {
            print("ERROR reloadFolders: \(error)")
        }
    }
    func addNewItem(author: String, imagePath: String) {
        let item = FavoriteItem(context: persistentContainer.viewContext)
        item.date = Date()
        item.image = imagePath
        item.author = author
        saveContext()
        reloadFolders()
    }
    func deleteFolder(folder: FavoriteItem) {
        persistentContainer.viewContext.delete(folder)
        saveContext()
        reloadFolders()
    }
    
    func checkDuplicate(imagePath: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteItem")
        fetchRequest.predicate = NSPredicate(format: "image == %@", argumentArray: [imagePath])
        let count = try! persistentContainer.viewContext.count(for: fetchRequest)
        guard count == 0 else {
            print("POST DUBLICATE")
            return false
        }
        return true
    }
}

