//
//  SplashReactor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/02.
//

import ReactorKit

final class SplashReactor: Reactor {
    var initialState: State = State()
    private var galleryRepository: TourPhotoJsonFetchable
    private let imageService = ImageService()
    private var photoInfos: [PhotoInfoEntity]?
    private lazy var galleryReactor = GalleryReactor()
    
    init(galleryRepository: TourPhotoJsonFetchable) {
        self.galleryRepository = galleryRepository
    }
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case doneAnimation(Bool)
    }
    
    enum Mutation {
        case loadView(Bool)
        case startAnimation(Bool)
        case fetchPhotoJson([PhotoInfoEntity])
        case hasReadyToPresent(Bool)
    }
    
    struct State {
        var isLoadView: Bool?
        var isStartAnimation: Bool?
        var isReadyToPresent: Bool?
        var galleryReactor: GalleryReactor?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let photoInfoEntities = galleryRepository
                .photoJsonFetch(by: 0)
                .share()
            
            return Observable.concat([
                Observable.just(Mutation.loadView(true)),
                photoInfoEntities.map { Mutation.fetchPhotoJson($0) }
            ])
            
        case .viewWillAppear:
            return Observable.just(Mutation.startAnimation(true))
        case .doneAnimation(let isDone):
            return Observable.just(Mutation.hasReadyToPresent(isDone))
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
            photoInfos = photos
            galleryReactor.setPhotoInfos(photoInfos: photos)
            newState.galleryReactor = galleryReactor
        case .hasReadyToPresent(let isAnimationDone):
            newState.isReadyToPresent = isAnimationDone
        }
        return newState
    }
}
