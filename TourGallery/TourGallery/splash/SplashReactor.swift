//
//  SplashReactor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/02.
//

import ReactorKit

final class SplashReactor: Reactor {
    var initialState: State = State()
    private let galleryRepository: TourPhotoJsonFetchable
    private let imageService = ImageService()
    
    init(galleryRepository: TourPhotoJsonFetchable) {
        self.galleryRepository = galleryRepository
    }
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
    }
    
    enum Mutation {
        case loadView(Bool)
        case startAnimation(Bool)
        case fetchPhotoJson([PhotoInfoEntity])
        case fetchFirstPhoto(Data?, NetworkError?)
    }
    
    struct State {
        var isLoadView: Bool?
        var isStartAnimation: Bool?
        var photoInfos: [PhotoInfoEntity]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let photoInfoEntities = galleryRepository
                .photoJsonFetch(by: 0)
                .map { $0 }
                .share()
            
            let twoPhotos = photoInfoEntities
                .map { $0.first }
                .compactMap { $0?.galWebImageURL }
                .flatMap { self.imageService.requestImage(from: $0) }
                .map({ result -> Mutation in
                    switch result {
                    case .success(let data):
                        return Mutation.fetchFirstPhoto(data, nil)
                    case .failure(let error):
                        return Mutation.fetchFirstPhoto(nil, error)
                    }
                })
                .share()
            
            return Observable.concat([
                Observable.just(Mutation.loadView(true)),
                photoInfoEntities.map { Mutation.fetchPhotoJson($0) },
                twoPhotos
            ])
            
        case .viewWillAppear:
            return Observable.just(Mutation.startAnimation(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView(let isLoaded):
            newState.isLoadView = isLoaded
        case .startAnimation(let isStarted):
            newState.isStartAnimation = isStarted
        case .fetchPhotoJson(let photos):
            newState.photoInfos = photos
        case .fetchFirstPhoto(let data, let error):
            newState.photoInfos?.first?.setGalImage(imageData: data)
            newState.photoInfos?.first?.setError(error: error)
        }
        return newState
    }
}
