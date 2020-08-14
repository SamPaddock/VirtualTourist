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
    
    
    class func flickerAPI(_ lat: Double = 24.774265, _ lon: Double = 46.738586, _ range: Int, completion: @escaping (_ data: [Photos]?,_ error: Error?) -> Void ){
        let randomPage = Int.random(in: 1 ... range)
        
        let urlComponents = createURL(lat, lon, randomPage)
        print(urlComponents)
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {completion(nil, error)}
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let decodedObject = try decoder.decode(FlickrResponse.self, from: data)
                let photoObject = decodedObject.photos.photo
                let newObject = convertResponse(photoObject, lat, lon)
                
                DispatchQueue.main.async { completion(newObject, nil) }
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
        let photosQuery = URLQueryItem(name: FlickrKeys.perPage, value: "21")
        let pageQuery = URLQueryItem(name: FlickrKeys.page, value: String(random))
        let formatQuery = URLQueryItem(name: FlickrKeys.format, value: FlickrValues.jsonFormat)
        let jsonCallbackQuery = URLQueryItem(name: FlickrKeys.nojsoncallback, value: FlickrValues.nojsoncallback)
        
        let itemQuery = [methodQuery, apiKeyQuery, tagQuery, accuracyQuery, latQuery, lonQuery, photosQuery, pageQuery, formatQuery, jsonCallbackQuery]
        
        urlComponents.queryItems = itemQuery
        
        return urlComponents
    }
    
    class func convertResponse(_ photoData: [PhotoSet], _ lat: Double, _ lon: Double) -> [Photos]{
        //Set pin locaton
        let pin: Pin = Pin()
        pin.latitude = lat
        pin.longitude = lon
        
        //convert response to data model
        var photos: [Photos] = []
        for photo in photoData {
            let newPhoto: Photos = Photos()
            let urlString = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
            newPhoto.location = pin
            newPhoto.photoURL = URL(string: urlString)
            photos.append(newPhoto)
        }
        
        return photos
    }
    
    //TODO: Display images as they are downloaded and replaces placeholders
    class func flickrGetPhoto(photoURL: URL, completion: @escaping (_ photoData: Data?, _ error: Error?) -> Void){
        let url = photoURL
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {completion(nil, error)}
                return
            }
            
            DispatchQueue.main.async {completion(data, nil)}
        }
        task.resume()

    }
}
