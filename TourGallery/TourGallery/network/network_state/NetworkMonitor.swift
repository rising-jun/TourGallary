//
//  NetworkMonitor.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/29.
//

import Foundation
import Network

protocol NetworkMonitoringable {
    func startMonitoring()
    func stopMonitoring()
}

struct NetworkMonitor: NetworkMonitoringable {
    private let monitor = NWPathMonitor()
    private let notificationCenter = NotificationCenter.default
    
    func startMonitoring() {
        var isConnected: Bool = false
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            notificationCenter.post(name: NetworkMonitor.Notification.Event.NetworkConnectionState, object: nil, userInfo: [NetworkMonitor.Notification.Key.connectionState : isConnected])
        }
    }
    
    func stopMonitoring() {
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
