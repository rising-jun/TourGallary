//
//  SceneReactorTest.swift
//  TourGalleryTests
//
//  Created by 김동준 on 2022/07/02.
//

import ReactorKit
import RxSwift
import XCTest
@testable import TourGallery

final class SceneReactorTest: XCTestCase {
    var reactor: SceneReactor!
    
    override func setUpWithError() throws {
        reactor = SceneReactor(networkMonitoringable: NetworkMonitorStub())
    }

    func test_sceneReactor() throws {
        let expectation = XCTestExpectation()
        
        reactor.action.onNext(.didInit)
        
        reactor.state.map { $0.hasNetworkChecking }
        .bind { isStart in
            XCTAssertEqual(true, isStart)
            expectation.fulfill()
        }
        .dispose()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
