//
//  GalleryViewController.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/05.
//

import SnapKit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = galleryView
    }
    
    func bind(reactor: GalleryReactor) {
    }
}
