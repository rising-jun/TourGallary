//
//  ViewController.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import UIKit
import RxAppState
import ReactorKit

final class SplashViewController: UIViewController, View {
    
    lazy var splashView = SplashView(frame: view.frame)
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.reactor = SplashReactor(galleryRepository: TourService())
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: SplashReactor) {
        rx.viewState
            .filter { $0 == .viewDidLoad }
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewState
            .filter { $0 == .viewWillAppear }
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoadView }
        .compactMap { $0 }
        .filter { $0 }
        .distinctUntilChanged()
        .bind(onNext: bindView)
        .disposed(by: disposeBag)
    }
}

private extension SplashViewController {
    func bindView(_: Bool) {
        self.view = splashView
    }
}
