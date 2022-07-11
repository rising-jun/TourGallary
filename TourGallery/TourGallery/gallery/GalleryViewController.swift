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
    //let dataSource = RxCollectionViewSectionedReloadDataSource<GallerySection>
    
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
        
        reactor.state.map { $0.photoInfos }
        .compactMap { $0 }
        .filter { $0.count > 0 }
        .do( onNext: { array in print("count!! \(array.count)") })
        .bind(to: galleryView.collectionView.rx.items(cellIdentifier: GalleryCollectionCell.id, cellType: GalleryCollectionCell.self)) { index, entity, cell in
            print("index \(index)")
            if let image = entity?.galleryImage {
                cell.setImage(from: image)
            }
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.updatedIndex }
        .compactMap { $0 }
        .distinctUntilChanged()
        .observe(on: MainScheduler.instance)
        .bind { [weak self] index in
            guard let self = self else { return }
            self.reloadCollectionView(index: index)
        }
        .disposed(by: disposeBag)
    }
}

private extension GalleryViewController {
    func bindView(_: Bool) {
        self.view = self.galleryView
    }
    
    func reloadCollectionView(index: Int) {
        //print("items count \(index) \(self.galleryView.collectionView.numberOfItems(inSection: 0))")
        //self.galleryView.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        //self.galleryView.collectionView.reloadData()
    }
}
