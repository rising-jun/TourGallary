//
//  TourService.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/30.
//

import Moya
import RxSwift

protocol TourPhotoJsonFetchable {
    var provider: MoyaProvider<TourAPI> { get }
    func photoJsonFetch(by photoSequence: Int) -> Observable<[PhotoInfo]>
}

final class TourService: TourPhotoJsonFetchable {
    var provider = MoyaProvider<TourAPI>()
    
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
