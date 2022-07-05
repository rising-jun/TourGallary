//
//  SplshView.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/02.
//

import SnapKit

final class SplashView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "splash_image") else { return UIImageView() }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(-20)
        }
        layoutIfNeeded()
    }
    
    private func attribute() {
        backgroundColor = .white
    }
}
