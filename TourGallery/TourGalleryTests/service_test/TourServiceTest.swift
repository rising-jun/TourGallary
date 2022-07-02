//
//  TourAPITest.swift
//  TourGalleryTests
//
//  Created by 김동준 on 2022/06/30.
//

import Moya
import RxSwift
import XCTest
@testable import TourGallery

final class TourServiceTest: XCTestCase {
    var tourService: TourPhotoJsonFetchable!
    
    override func setUpWithError() throws {
        tourService = TourServiceStub()
    }

    func test_requestFetchPhotoJson() throws {
        let expectation = XCTestExpectation()
        guard let json = Bundle.main.path(forResource: "TourGalleryPhoto", ofType: "json") else { return XCTFail() }
        guard let jsonString = try? String(contentsOfFile: json) else { return XCTFail() }
        guard let mockData = jsonString.data(using: .utf8) else { return XCTFail() }
        
        guard let expectedCount = try? JSONDecoder().decode(Welcome.self, from: mockData).response.body.items.photoInfos.count else { return XCTFail() }
        
        tourService.photoJsonFetch(by: 0).bind(onNext: { photoInfos in
            XCTAssertEqual(expectedCount, photoInfos.count)
            expectation.fulfill()
        })
        .dispose()
        wait(for: [expectation], timeout: 2.0)
    }
}
