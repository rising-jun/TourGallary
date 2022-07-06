//
//  GalleryView.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/05.
//

import SnapKit

final class GalleryView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: GalleryCollectionCell.id)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 350, height: 500)
        layout.minimumLineSpacing = 0
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(500)
            make.center.equalToSuperview()
        }
        
    }
    
    private func attribute() {
        backgroundColor = .white
        collectionView.backgroundColor = .yellow
    }
}


