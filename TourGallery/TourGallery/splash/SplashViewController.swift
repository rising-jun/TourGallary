//
//  ViewController.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import SnapKit
import RxAppState
import ReactorKit
import RxRelay

final class SplashViewController: UIViewController, View {
    
    lazy var splashView = SplashView(frame: view.frame)
    var disposeBag: DisposeBag = DisposeBag()
    private let animationDoneRelay = PublishRelay<Bool>()
    
    private var gallerayReactor: GalleryReactor?
    
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

        animationDoneRelay
            .filter { $0 }
            .map { Reactor.Action.doneAnimation($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoadView }
        .compactMap { $0 }
        .filter { $0 }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] result in
            guard let self = self else { return }
            self.bindView(result)
        })
        //.bind(onNext: bindView)
        .disposed(by: disposeBag)

        reactor.state.map { $0.isStartAnimation }
        .compactMap { $0 }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] result in
            guard let self = self else { return }
            self.startAnimation(result)
        })
        //.bind(onNext: startAnimation)
        .disposed(by: disposeBag)

        reactor.state.map { $0.galleryReactor }
        .compactMap { $0 }
        .take(1)
        .bind(onNext: { [weak self] result in
            guard let self = self else { return }
            self.setGalleryReactor(gallerayReactor: result)
        })
        //.bind(onNext: setGalleryReactor)
        .disposed(by: disposeBag)

        reactor.state.map { $0.isReadyToPresent }
        .compactMap { $0 }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] result in
            guard let self = self else { return }
            self.presentGalleryViewController(result)
        })
        //.bind(onNext: presentGalleryViewController)
        .disposed(by: disposeBag)
    }
}

private extension SplashViewController {
    func bindView(_: Bool) {
        self.view = splashView
    }
    
    func startAnimation(_: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 4) {
                self.splashView.imageView.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().offset(20)
                    make.leading.equalToSuperview()
                }
                self.splashView.layoutIfNeeded()
            } completion: { isDone in
                self.animationDoneRelay.accept(isDone)
            }
        }
    }
    
    func setGalleryReactor(gallerayReactor: GalleryReactor) {
        self.gallerayReactor = gallerayReactor
    }
    
    func presentGalleryViewController(_: Bool) {
        let galleryViewController = GalleryViewController()
        galleryViewController.modalPresentationStyle = .fullScreen
        if self.gallerayReactor != nil {
            galleryViewController.reactor = gallerayReactor
        }else {
            galleryViewController.reactor = GalleryReactor()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController = galleryViewController
            self.dismiss(animated: true, completion: nil)
            self.present(galleryViewController, animated: true)
        }
    }
}
