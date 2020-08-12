//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 23/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate {

    //MARK: properties
    @IBOutlet weak var mapScene: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    
    var coordinate: CLLocationCoordinate2D? = nil
    var pin: Pin!
    
    var dataController: DataController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    
    //TODO: If pin tapped, does not contain photos, download from flickr
    
    //TODO: If pin tapped, does have images, no download needed
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapScene.delegate = self
        photoAlbumCollectionView.delegate = self
        placePinLocation()
        downloadImages()
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
        print("downloading")
        guard let coordinate = coordinate else {return}
        ImageRetrieval.flickerAPI(coordinate.latitude, coordinate.longitude, 1) { (response, error) in
            if let response = response {
                self.downloadImage(response.photos.photo)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    func downloadImage(_ photos: [PhotoSet]){
        for photo in photos {
            ImageRetrieval.flickrGetPhoto(photo: photo) { (photoData, photoURL, error) in
                if let photoData = photoData,  let photoURL = photoURL{
                    self.storePhoto(photoData, photoURL)
                } else {
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
    }
    
    //TODO: Stroe images an binary data in Photo entity (Allow External storage)
    func storePhoto(_ photo: Data,_ url: URL){
        let photoContext = Photos(context: dataController.viewContext)
        photoContext.photoData = photo
        photoContext.photoURL = url
        photoContext.location = self.pin
        try? dataController.viewContext.save()
    }
    //TODO: tapped images are removed from collection view, photo album, and core data
    
    //TODO: "New Collection" button redownloads new images from other pages (use random value for "page" parameter)


}
