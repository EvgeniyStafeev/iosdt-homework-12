//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let tabBarVC = UITabBarController()
    let realmService = RealmService()
    let realm = try! Realm()
    let userDefault = UserDefaults.standard
    let coreDataManager = CoreDataManager.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        //realmService.createCategory(name: "Users")
        
        let loginVC = LogInViewController()
        loginVC.tabBarItem.title = "Вход"
        loginVC.tabBarItem.image = UIImage(systemName: "person.crop.square")
        loginVC.tabBarItem.tag = 1
        let feedVC = FeedViewController()
        feedVC.tabBarItem.title = "Лента"
        feedVC.tabBarItem.image = UIImage(systemName: "book")
        feedVC.tabBarItem.tag = 0
        let profilVC = ProfileViewController()
        profilVC.tabBarItem.title = "Профиль"
        profilVC.tabBarItem.image = UIImage(systemName: "person.crop.square")
        profilVC.tabBarItem.tag = 3
        let favoriteVC = FavoriteViewController()
        favoriteVC.tabBarItem.title = "Избранное"
        favoriteVC.tabBarItem.image = UIImage(systemName: "star")
        favoriteVC.tabBarItem.tag = 4
        
      
        let factory = MyLoginFactory()
        loginVC.loginDelegate = factory.makeLoginInspector()
        let loginNC = UINavigationController(rootViewController: loginVC)
        let feedNC = UINavigationController(rootViewController: feedVC)
        let profilNC = UINavigationController(rootViewController: profilVC)
        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        tabBarVC.setViewControllers([feedNC,loginNC], animated: true)
        
        let allCategory = realm.objects(Category.self)
        guard let usersCategory = realm.object(ofType: Category.self, forPrimaryKey: allCategory.first?.id) else { return }
        let loginIn = userDefault.string(forKey: "login")
        let passwordIn = userDefault.string(forKey: "password")
        for user in usersCategory.users {
            if loginIn == user.login && passwordIn == user.password {
                print("Welcome to PROFILEVC")
                tabBarVC.setViewControllers([feedNC, profilNC, favoriteNC], animated: true)
            }
        }
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

