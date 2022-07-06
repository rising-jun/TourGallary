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
    private let imageManager = ImageService()
    
    init() { }
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
    }
    
    enum Mutation {
        case loadView(Bool)
        case loadPhotoInfo([PhotoInfoEntity]?)
    }
    
    struct State {
        var isLoadView: Bool?
        var photoInfos: [PhotoInfoEntity]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.just(Mutation.loadView(true))
        case .viewWillAppear:
            return Observable.just(Mutation.loadPhotoInfo(self.photoInfos))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView(let isLoaded):
            newState.isLoadView = isLoaded
        case .loadPhotoInfo(let photoInfos):
            newState.photoInfos = photoInfos
        }
        return newState
    }
}
extension GalleryReactor {
    func setPhotoInfos(photoInfos: [PhotoInfoEntity]) {
        self.photoInfos = photoInfos
    }
}

