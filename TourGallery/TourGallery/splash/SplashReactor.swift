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
        case fetchPhotoJson([PhotoInfo])
    }
    
    struct State {
        var isLoadView: Bool?
        var isStartAnimation: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                Observable.just(Mutation.loadView(true)),
                galleryRepository.photoJsonFetch(by: 0).map { Mutation.fetchPhotoJson($0) }])
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
            print(photos.count)
            return newState
        }
        return newState
    }
}
