//
//  ImageService.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/04.
//

import RxSwift

struct ImageService {
    func requestImage(from imageURL: String) -> Observable<Result<Data, NetworkError> > {
        guard let url = URL(string: imageURL) else { return Observable.just(.failure(.invailedURL)) }
        return URLSession.shared.rx
            .data(request: URLRequest(url: url))
            .map { .success($0) }
    }
}

enum NetworkError: Error {
    case invailedURL
    case inTask
    case nilData
}
