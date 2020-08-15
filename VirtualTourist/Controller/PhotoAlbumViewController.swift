//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 23/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Kingfisher

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: properties
    @IBOutlet weak var mapScene: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    
    var coordinate: CLLocationCoordinate2D? = nil
    var pin: Pin!
    var photoAlbum: [Photos] = []
    var photoResponse: FlickrResponse!
    var pages: Int = 1
    
    var dataController: DataController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate views to self
        mapScene.delegate = self
        photoAlbumCollectionView.delegate = self
        photoAlbumCollectionView.dataSource = self
        //Show location of photos
        placePinLocation()
        //Check if there are saved photos of that location
        fetchPhotos()
    }
    
    //Function to place pin on the map of tapped location
    func placePinLocation(){
        guard let sentCoordinates = coordinate else {return}
        let annotation = MKPointAnnotation()
        annotation.coordinate = sentCoordinates
        self.mapScene.addAnnotation(annotation)
        
        //center map view on selected location
        let region = MKCoordinateRegion(center: sentCoordinates, span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))
        mapScene.setRegion(region, animated: true)
    }
    
    //Function to fetch photos from DataCore, if it does not contain photos, download from flickr
    func fetchPhotos(){
        print("fetching images")
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "location = %@", pin)
        if let results = try? dataController.viewContext.fetch(fetchRequest), results.count != 0 {
            //Set photos from data core
            print("fetching from core data")
            photoAlbum = results
        } else {
            //Download photos from flickr
            print("fetching from flickr")
            downloadImages()
        }
    }
    
    //Function to download photo information from Flickr
    func downloadImages(){
        guard let coordinate = coordinate else {return}
        photoAlbum.removeAll()
        ImageRetrieval.flickerAPI(coordinate.latitude, coordinate.longitude, pages) { (response, error) in
            if let response = response {
                self.pages = response.photos.pages
                self.downloadPhotos(response)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    //MARK: Collection View Data Source

    //get number of photos to set number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photoAlbum.count)
        return photoAlbum.count
    }

    //Fill cells with photos from album
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoAlbumCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        let photoCell = photoAlbum[indexPath.row]
        cell.photo.image = UIImage(data: photoCell.photoData!)
        
        return cell
    }
    
    func downloadPhotos(_ response : FlickrResponse){
        print("\n Getting data array")
        let imageArray = response.photos.photo
        print(imageArray)
        for image in imageArray {
            
            let imageURL = URL(string: image.urlM)
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: imageURL) { (result, error, cache, url) in
                if error == nil {
                    let imageData = result!.pngData()!
                    self.storePhoto(imageData, url!)
                } else {
                    print(error)
                }
            }
        }
    }
    
    //Function to Stroe images as binary data in Photo entity
    func storePhoto(_ photo: Data,_ url: URL){
        print("Setting image")
        let photoContext = Photos(context: dataController.viewContext)
        photoContext.photoData = photo
        photoContext.photoURL = url
        photoContext.location = self.pin
        try? dataController.viewContext.save()
        photoAlbum.append(photoContext)
        photoAlbumCollectionView.reloadData()
    }
    
    //TODO: tapped images are removed from collection view, photo album, and core data
    
    //TODO: "New Collection" button redownloads new images from other pages (use random value for "page" parameter)


}
