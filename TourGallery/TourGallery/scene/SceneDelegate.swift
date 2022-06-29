//
//  SceneDelegate.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import UIKit
import ReactorKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, View {
    var window: UIWindow?
    
    override init() {
        super.init()
        self.reactor = SceneReactor()
    }
    var disposeBag = DisposeBag()
    
    func bind(reactor: SceneReactor) {
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = SplashViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

extension SceneDelegate {
    func startNetworkingMonitor() {
        let monitor = NetworkMonitor()
        monitor.startMonitoring()
    }
}
