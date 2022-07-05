//
//  SceneReactor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import ReactorKit

final class SceneReactor: Reactor {
    var initialState = State()
    private let networkMonitoringable: NetworkMonitoringable
    
    init(networkMonitoringable: NetworkMonitoringable) {
        self.networkMonitoringable = networkMonitoringable
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
            networkMonitoringable.startMonitoring()
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
