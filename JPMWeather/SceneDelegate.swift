//
//  SceneDelegate.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //setting up the UI programmtically as opposed to using storyboards.
        //My preferred way of writing UI as merge conflicts are easier to fix
        //and code is easier to change
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = MainViewController()
        
        if let lat = UserDefaults.standard.object(forKey: "geolat") as? String,
           let lon = UserDefaults.standard.object(forKey: "geolon") as? String {
            viewController.getWeather(lat: lat, lon: lon)
            
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

