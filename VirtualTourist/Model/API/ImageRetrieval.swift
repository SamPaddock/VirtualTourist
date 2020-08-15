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
    
    //MARK: API Download Function
    
    //Create session to retrieve photos of sent location
    class func flickerAPI(_ lat: Double, _ lon: Double, _ range: Int, completion: @escaping (_ data: FlickrResponse?,_ error: Error?) -> Void ){
        //Generate random digit from 1 to total number of pages
        let randomPage = Int.random(in: 1 ... range)
        //Create the url link
        let urlComponents = createURL(lat, lon, randomPage)
        //Start session to retrieve the data
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {completion(nil, error)}
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                //decode data using codable structure
                let decodedObject = try decoder.decode(FlickrResponse.self, from: data)
                DispatchQueue.main.async { completion(decodedObject, nil) }
            } catch {
                DispatchQueue.main.async {completion(nil, error)}
            }
        }
        task.resume()
        
    }
    
    //MARK: URL Creation FUnction
    
    //Compose url link with query
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
