//
//  apiConstants.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 12/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

struct FlickrURL {
    static let scheme = "https"
    static let host = "api.flickr.com"
    static let path = "/services/rest/"
    static let apiKey = "5432ff94da1afa0805fba476169b2e86"
}

struct FlickrMethod {
    static let photoSearch = "flickr.photos.search"
}

struct FlickrKeys {
    static let apiKey = "api_key"
    static let method = "method"
    static let accuracy = "accuracy"
    static let tag = "tag"
    static let latitude = "lat"
    static let longitude = "lon"
    static let perPage = "per_page"
    static let page = "page"
    static let format = "format"
    static let nojsoncallback = "nojsoncallback"
    static let extra = "extras"
}

struct FlickrValues {
    static let cityAccuracy = "11"
    static let jsonFormat = "json"
    static let nojsoncallback = "1"
    static let extraURL = "url_m"
}

