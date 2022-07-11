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
import RxDataSources

final class GalleryViewController: UIViewController, View {
    lazy var galleryView = GalleryView(frame: view.frame)
    var disposeBag: DisposeBag = DisposeBag()
    
    let photoCelldataSource = RxCollectionViewSectionedReloadDataSource<SectionOfPhotoInfo>(
        configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionCell.id, for: indexPath) as? GalleryCollectionCell else { return UICollectionViewCell() }
            if let image = item.galleryImage {
                cell.setImage(from: image)
            }
            return cell
        })
    
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
        .compactMap { $0?.compactMap { $0 } }
        .filter { $0.count > 0 }
        .map { [SectionOfPhotoInfo(items: $0)] }
        .bind(to: galleryView.collectionView.rx.items(dataSource: photoCelldataSource))
        .disposed(by: disposeBag)
    }
}

private extension GalleryViewController {
    func bindView(_: Bool) {
        self.view = self.galleryView
    }
}
