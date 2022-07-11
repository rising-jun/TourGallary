//
//  SectionOfPhotoInfo.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/11.
//

import RxDataSources

struct SectionOfPhotoInfo {
    var items: [Item]
}
extension SectionOfPhotoInfo: SectionModelType {
    typealias Item = PhotoInfoEntity
    init(original: SectionOfPhotoInfo, items: [Item]) {
        self = original
        self.items = items
    }
}
