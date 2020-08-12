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
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
