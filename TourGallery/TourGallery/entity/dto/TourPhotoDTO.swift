//
//  TourPhotoDTO.swift
//  TourGallery
//
//  Created by 김동준 on 2022/07/02.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let photoInfos: [PhotoInfo]
    
    enum CodingKeys: String, CodingKey {
        case photoInfos = "item"
    }
}

// MARK: - Item
struct PhotoInfo: Codable {
    let galContentID, galContentTypeID, galCreatedtime, galModifiedtime: Int
    let galPhotographer, galPhotographyLocation: String
    let galPhotographyMonth: Int
    let galSearchKeyword, galTitle: String
    let galViewCount: Int
    let galWebImageURL: String

    enum CodingKeys: String, CodingKey {
        case galContentID = "galContentId"
        case galContentTypeID = "galContentTypeId"
        case galCreatedtime, galModifiedtime, galPhotographer, galPhotographyLocation, galPhotographyMonth, galSearchKeyword, galTitle, galViewCount
        case galWebImageURL = "galWebImageUrl"
    }
    
    func convertPhotoInfo() -> PhotoInfoEntity {
        return PhotoInfoEntity(photoInfo: self)
    }
}

final class PhotoInfoEntity {
    var galContentID, galCreatedtime: Int
    let galPhotographer, galPhotographyLocation: String
    let galPhotographyMonth: Int?
    let galSearchKeyword, galTitle: String?
    let galWebImageURL: String
    private(set) var galleryImage: Data?
    private(set) var errorState: NetworkError?
    
    init(photoInfo: PhotoInfo) {
        galContentID = photoInfo.galContentID
        galCreatedtime = photoInfo.galCreatedtime
        galPhotographyLocation = photoInfo.galPhotographyLocation
        galPhotographyMonth = photoInfo.galPhotographyMonth
        galPhotographer = photoInfo.galPhotographer
        galSearchKeyword = photoInfo.galSearchKeyword
        galTitle = photoInfo.galTitle
        galWebImageURL = photoInfo.galWebImageURL
    }
    
    func setGalImage(imageData: Data?) {
        galleryImage = imageData
    }
    
    func setError(error: NetworkError?) {
        errorState = error
    }
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}

extension Array {
    func convertLinkedList() -> LinkedList<Element> {
        let list = LinkedList<Element>()
        for element in self {
            let node = Node<Element>()
            node.val = element
            list.add(node: node)
        }
        return list
    }
}
