//
//  File.swift
//  TourGalleryTests
//
//  Created by 김동준 on 2022/07/02.
//

import Foundation
@testable import TourGallery

struct NetworkMonitorStub: NetworkMonitoringable {
    func startMonitoring() { }
    
    func stopMonitoring() { }
}

