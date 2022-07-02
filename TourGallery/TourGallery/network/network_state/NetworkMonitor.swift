//
//  NetworkMonitor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import Foundation
import Network

struct NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let notificationCenter = NotificationCenter.default
    
    public func startMonitoring() {
        var isConnected: Bool = false
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            notificationCenter.post(name: NetworkMonitor.Notification.Event.NetworkConnectionState, object: nil, userInfo: [NetworkMonitor.Notification.Key.connectionState : isConnected])
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}

extension NetworkMonitor {
    enum Notification{
        enum Key{
            case connectionState
        }
        enum Event{
            static let NetworkConnectionState = Foundation.Notification.Name.init("NetworkConnectionState")
        }
    }
}
