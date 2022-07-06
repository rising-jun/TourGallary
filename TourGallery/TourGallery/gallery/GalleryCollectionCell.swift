//
//  GalleryCollectionCell.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/06.
//

import SnapKit

final class GalleryCollectionCell: UICollectionViewCell {
    static var id = String(describing: self)
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubviews(imageView, titleLabel, subLabel)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.backgroundColor = .blue
    }
    
    func setImage(from data: Data) {
        imageView.image = UIImage(data: data)
    }
}
