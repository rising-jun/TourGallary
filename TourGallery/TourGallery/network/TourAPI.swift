//
//  TourAPI.swift
//  TourGallery
//
//  Created by 김동준 on 2022/06/30.
//

import Moya

enum TourAPI {
    private var serviceKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "serviceKey") as? String else { return "" }
        guard let decodeKey = apiKey.removingPercentEncoding else { return "" }
        return decodeKey
    }
    case fetchPhotoJson
}
extension TourAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.visitkorea.or.kr/openapi/service/rest/PhotoGalleryService")!
    }

    var path: String {
        switch self {
        case .fetchPhotoJson:
            return "/galleryList"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchPhotoJson:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchPhotoJson:
            guard let json = Bundle.main.path(forResource: "TourGalleryPhoto", ofType: "json") else { return Data() }
            guard let jsonString = try? String(contentsOfFile: json) else { return Data() }
            guard let mockData = jsonString.data(using: .utf8) else { return Data() }
            return mockData
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPhotoJson:
            let params: [String: Any] = ["ServiceKey": serviceKey,
                          "pageNo": "1",
                          "numOfRows": "10",
                          "MobileOS": "ETC",
                          "MobileApp": "AppTest",
                          "arrange": "A",
                          "_type": "json"]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
