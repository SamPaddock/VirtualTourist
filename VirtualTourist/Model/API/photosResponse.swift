//
//  photosResponse.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 12/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

// MARK: - FlickrResponse
struct FlickrResponse: Codable {
    let photos: PhotosSet
    let stat: String
}

// MARK: - Photos
struct PhotosSet: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [PhotoSet]
}

// MARK: - Photo
struct PhotoSet: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let urlM: String
    let heightM, widthM: Int

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case urlM = "url_m"
        case heightM = "height_m"
        case widthM = "width_m"
    }
}
