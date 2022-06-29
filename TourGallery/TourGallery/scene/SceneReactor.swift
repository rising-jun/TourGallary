//
//  SceneReactor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import ReactorKit

final class SceneReactor: Reactor {
    var initialState = State()
    
    
    enum Action {
        case didInit
    }
    
    enum Mutation {
        case startNetworkMonitor(Bool)
    }
    
    struct State {
        var hasNetworkChecking: Bool?
    }
    
    
}
