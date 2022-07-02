//
//  TourServiceStub.swift
//  TourGalleryTests
//
//  Created by 김동준 on 2022/06/30.
//

import Moya
import RxSwift
@testable import TourGallery

final class TourServiceStub: TourPhotoJsonFetchable {
    var provider = MoyaProvider<TourAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    func photoJsonFetch(by photoSequence: Int) -> Observable<[PhotoInfo]> {
        provider.rx
            .request(.fetchPhotoJson)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Welcome.self)
            .map { $0.response.body.items.photoInfos }
            .compactMap { $0 }
    }
}
