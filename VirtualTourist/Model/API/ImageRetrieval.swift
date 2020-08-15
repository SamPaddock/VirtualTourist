//
//  ImageRetrieval.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 23/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit

//Class to download images from Flickr
class ImageRetrieval{
    
    var dataController: DataController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    
    class func flickerAPI(_ lat: Double = 24.774265, _ lon: Double = 46.738586, _ range: Int, completion: @escaping (_ data: FlickrResponse?,_ error: Error?) -> Void ){
        let randomPage = Int.random(in: 1 ... range)
        
        let urlComponents = createURL(lat, lon, randomPage)
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {completion(nil, error)}
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let decodedObject = try decoder.decode(FlickrResponse.self, from: data)
                DispatchQueue.main.async { completion(decodedObject, nil) }
            } catch {
                DispatchQueue.main.async {completion(nil, error)}
            }
        }
        task.resume()
        
    }
    
    class func createURL(_ lat: Double, _ lon: Double, _ random: Int) -> URLComponents {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = FlickrURL.scheme
        urlComponents.host = FlickrURL.host
        urlComponents.path = FlickrURL.path
        
        let methodQuery = URLQueryItem(name: FlickrKeys.method, value: FlickrMethod.photoSearch)
        let apiKeyQuery = URLQueryItem(name: FlickrKeys.apiKey, value: FlickrURL.apiKey)
        let tagQuery = URLQueryItem(name: FlickrKeys.tag, value: "")
        let accuracyQuery = URLQueryItem(name: FlickrKeys.accuracy, value: FlickrValues.cityAccuracy)
        let latQuery = URLQueryItem(name: FlickrKeys.latitude, value: String(lat))
        let lonQuery = URLQueryItem(name: FlickrKeys.longitude, value: String(lon))
        let extraQuery = URLQueryItem(name: FlickrKeys.extra, value: FlickrValues.extraURL)
        let photosQuery = URLQueryItem(name: FlickrKeys.perPage, value: "21")
        let pageQuery = URLQueryItem(name: FlickrKeys.page, value: String(random))
        let formatQuery = URLQueryItem(name: FlickrKeys.format, value: FlickrValues.jsonFormat)
        let jsonCallbackQuery = URLQueryItem(name: FlickrKeys.nojsoncallback, value: FlickrValues.nojsoncallback)
        
        
        let itemQuery = [methodQuery, apiKeyQuery, tagQuery, accuracyQuery, latQuery, lonQuery, extraQuery, photosQuery, pageQuery, formatQuery, jsonCallbackQuery]
        
        urlComponents.queryItems = itemQuery
        
        return urlComponents
    }
}
