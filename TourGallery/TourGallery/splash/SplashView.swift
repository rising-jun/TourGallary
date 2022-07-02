//
//  SplshView.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/02.
//

import SnapKit

final class SplashView: UIView {
    
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
        
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
}
