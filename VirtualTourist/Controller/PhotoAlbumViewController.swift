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

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: properties
    @IBOutlet weak var mapScene: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    
    var coordinate: CLLocationCoordinate2D? = nil
    var pin: Pin!
    var photoAlbum: [PhotoSet] = []
    var photos: [Photos] = []
    
    var dataController: DataController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    
    //TODO: If pin tapped, does not contain photos, download from flickr
    
    //TODO: If pin tapped, does have images, no download needed
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Delegate views to self
        mapScene.delegate = self
        photoAlbumCollectionView.delegate = self
        photoAlbumCollectionView.dataSource = self
        //Show location of photos
        placePinLocation()
        //TODO: Check if there are saved photos of that location
        downloadImages()
    }
    
    func fetchPhotos(){
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin = %@", pin)
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            photos = results
        }
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
    
    func downloadImages(){
        guard let coordinate = coordinate else {return}
        photoAlbum.removeAll()
        ImageRetrieval.flickerAPI(coordinate.latitude, coordinate.longitude, 1) { (response, error) in
            if let response = response {
                print("saving response")
                print(response.photos.photo)
                self.photoAlbum = response.photos.photo
                self.photoAlbumCollectionView.reloadData()
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    //Function to Stroe images as binary data in Photo entity
    func storePhoto(_ photo: Data,_ url: URL){
        let photoContext = Photos(context: dataController.viewContext)
        photoContext.photoData = photo
        photoContext.photoURL = url
        photoContext.location = self.pin
        try? dataController.viewContext.save()
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
        
        cell.photo.backgroundColor = .gray
        let photo = photoAlbum[indexPath.row]
        
        ImageRetrieval.flickrGetPhoto(photo: photo) { (photoData, photoURL, error) in
            if let photoData = photoData,  let photoURL = photoURL{
                self.storePhoto(photoData, photoURL)
                cell.photo.backgroundColor = .none
                cell.photo.image = UIImage(data: photoData)
                cell.setNeedsLayout()
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    
        return cell
    }
    
    
    //TODO: tapped images are removed from collection view, photo album, and core data
    
    //TODO: "New Collection" button redownloads new images from other pages (use random value for "page" parameter)


}
