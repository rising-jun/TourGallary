//
//  extension+UIView.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/06.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView ... ){
        for view in views {
            addSubview(view)
        }
    }
}
