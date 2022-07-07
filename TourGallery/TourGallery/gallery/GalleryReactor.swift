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
    private let photoList = LinkedList<PhotoInfoEntity>()
    
    init() { }
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
    }
    
    enum Mutation {
        case loadView(Bool)
        case loadPhotoInfo([PhotoInfoEntity]?)
        case fetchCompletePhotoInfo(Node<PhotoInfoEntity>?)
    }
    
    struct State {
        var isLoadView: Bool?
        var photoInfos: [PhotoInfoEntity]?
        var photoList = LinkedList<PhotoInfoEntity>()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.just(Mutation.loadView(true))
        case .viewWillAppear:
            let photoRelay = PublishRelay<Node<PhotoInfoEntity> >()
            if let photoInfos = self.photoInfos {
                for (index, photoInfo) in photoInfos.enumerated() {
                    let manager = imageManager.requestImage(from: photoInfo.galWebImageURL)
                        .map { [unowned self] result -> PhotoInfoEntity? in
                            switch result {
                            case .success(let imageData):
                                self.photoInfos?[index].setGalImage(imageData: imageData)
                            case .failure(let error):
                                self.photoInfos?[index].setError(error: error)
                            }
                            return photoInfos[index]
                        }
                        .compactMap { $0 }
                        .map { [unowned self] value in
                            return self.makeNode(val: value)
                        }
                        .bind(to: photoRelay)
                }
            }
            return photoRelay.map { Mutation.fetchCompletePhotoInfo($0) }
//            return Observable.just(Mutation.loadPhotoInfo(self.photoInfos))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView(let isLoaded):
            newState.isLoadView = isLoaded
        case .loadPhotoInfo(let photoInfos):
            print("asdf")
            //newState.photoInfos = photoInfos
        case .fetchCompletePhotoInfo(let node):
            guard let node = node else { return newState }
            newState.photoList.add(node: node)
        }
        return newState
    }
}
extension GalleryReactor {
    func setPhotoInfos(photoInfos: [PhotoInfoEntity]) {
        self.photoInfos = photoInfos
    }
    
    private func makeNode(val: PhotoInfoEntity) -> Node<PhotoInfoEntity> {
        let node = Node<PhotoInfoEntity>()
        node.val = val
        return node
    }
}

