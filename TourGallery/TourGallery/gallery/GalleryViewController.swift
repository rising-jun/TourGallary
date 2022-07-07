//
//  GalleryViewController.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/05.
//

import SnapKit
import RxAppState
import RxSwift
import ReactorKit

final class GalleryViewController: UIViewController, View {
    lazy var galleryView = GalleryView(frame: view.frame)
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: GalleryReactor) {
        rx.viewDidLoad.map { _ in Reactor.Action.viewDidLoad }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        rx.viewWillAppear.map { _ in Reactor.Action.viewWillAppear }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoadView }
        .compactMap { $0 }
        .distinctUntilChanged()
        .bind(onNext: bindView)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.photoList }
        .compactMap { $0 }
        .do(onNext: { _ in print("hello~~~") })
        .bind(to: galleryView.collectionView.rx.items(cellIdentifier: GalleryCollectionCell.id, cellType: GalleryCollectionCell.self)) { index, entity, cell in
            if let image = entity.galleryImage {
                cell.setImage(from: image)
            }
            print("image is nil")
        }
        .disposed(by: disposeBag)
    }
}
private extension GalleryViewController {
    func bindView(_: Bool) {
        //DispatchQueue.main.async {
            self.view = self.galleryView
        //}
    }
}
