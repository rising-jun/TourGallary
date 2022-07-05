//
//  GalleryReactor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/05.
//

import ReactorKit

final class GalleryReactor: Reactor {
    var initialState = State()
    private var photoInfos: [PhotoInfoEntity]?
    
    init() {
        
    }
    
    enum Action {
        case didInit
    }
    
    enum Mutation {
        case startNetworkMonitor(Bool)
    }
    
    struct State {
        var hasNetworkChecking: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didInit:
            return Observable.just(Mutation.startNetworkMonitor(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .startNetworkMonitor(let isStarted):
            newState.hasNetworkChecking = isStarted
        }
        return newState
    }
}
extension GalleryReactor {
    func setPhotoInfos(photoInfos: [PhotoInfoEntity]) {
        self.photoInfos = photoInfos
    }
}

