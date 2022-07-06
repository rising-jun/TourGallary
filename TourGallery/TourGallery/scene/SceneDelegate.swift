//
//  SceneDelegate.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import UIKit
import ReactorKit
import RxRelay

class SceneDelegate: UIResponder, UIWindowSceneDelegate, View {
    var window: UIWindow?
    
    private let sceneInitRelay = PublishRelay<Void>()
    
    override init() {
        super.init()
        self.reactor = SceneReactor(networkMonitoringable: NetworkMonitor())
        sceneInitRelay.accept(())
    }
    
    var disposeBag = DisposeBag()
    
    func bind(reactor: SceneReactor) {
        sceneInitRelay.map { Reactor.Action.didInit }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.hasNetworkChecking }
        .compactMap { $0 }
        .filter { $0 }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] result in
            guard let self = self else { return }
            self.setRootToSplash(result)
        })
        //.bind(onNext: setRootToSplash)
        .disposed(by: disposeBag)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

private extension SceneDelegate {
    func setRootToSplash(_: Bool) {
        DispatchQueue.main.async {
            self.window?.rootViewController = SplashViewController()
        }
    }
}
