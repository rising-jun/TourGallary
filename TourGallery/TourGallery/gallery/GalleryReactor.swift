//
//  GalleryReactor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/05.
//

import ReactorKit
import RxRelay

final class GalleryReactor: Reactor {
    var initialState = State()
    private var photoInfos: [PhotoInfoEntity]?
    private let imageManager = ImageService()
    private let disposeBag = DisposeBag()
    private let photoRelay = PublishRelay<[Int: PhotoInfoEntity]>()
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
    }
    
    enum Mutation {
        case loadView(Bool)
        case loadPhotoInfo([PhotoInfoEntity?]?)
        case fetchCompletePhotoInfo([Int: PhotoInfoEntity])
    }
    
    struct State {
        var isLoadView: Bool?
        var photoInfos: [PhotoInfoEntity?]?
        var updatedIndex: Int?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.just(Mutation.loadView(true))
        case .viewWillAppear:
            guard let photoInfos = photoInfos else {
                return Observable.just(Mutation.loadPhotoInfo(nil))
            }
            
            
            for (index, photoInfo) in photoInfos.enumerated() {
                imageManager.requestImage(from: photoInfo.galWebImageURL)
                    .map { [unowned self] result -> [Int: PhotoInfoEntity] in
                        switch result {
                        case .success(let imageData):
                            self.photoInfos?[index].setGalImage(imageData: imageData)
                        case .failure(let error):
                            self.photoInfos?[index].setError(error: error)
                        }
                        return [index: photoInfos[index]]
                    }
                    .bind(to: photoRelay)
                    .disposed(by: disposeBag)
            }
            return Observable.concat([Observable.just(Mutation.loadPhotoInfo([PhotoInfoEntity?](repeating: nil, count: self.photoInfos?.count ?? 0))),
                                      photoRelay.map { Mutation.fetchCompletePhotoInfo($0) }])

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView(let isLoaded):
            newState.isLoadView = isLoaded
        case .loadPhotoInfo(let photoInfos):
            guard let photoInfos = photoInfos else { return newState }
            newState.photoInfos = photoInfos
        case .fetchCompletePhotoInfo(let photoDicionary):
            guard let index = photoDicionary.keys.first else { return newState }
            guard let value = photoDicionary[index] else { return newState }
            print("react")
            newState.photoInfos?[index] = value
            newState.updatedIndex = index
        }
        return newState
    }
}
extension GalleryReactor {
    func setPhotoInfos(photoInfos: [PhotoInfoEntity]) {
        self.photoInfos = photoInfos
    }
}

