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

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    //MARK: properties
    //Outlet properties
    @IBOutlet weak var mapScene: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    //Location properties
    var coordinate: CLLocationCoordinate2D? = nil
    var pin: Pin!
    
    //Data related properties
    var photoAlbum: [Photos] = []
    var photoResponse: FlickrResponse!
    var pages: Int = 1
    
    //Data Controller property
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
    
    //MARK: Setting UI
    
    //Function to place pin on the map of tapped location
    func placePinLocation(){
        guard let sentCoordinates = coordinate else {return}
        //Create and place pin of selected location
        let annotation = MKPointAnnotation()
        annotation.coordinate = sentCoordinates
        self.mapScene.addAnnotation(annotation)
        
        //center map view on selected location
        let region = MKCoordinateRegion(center: sentCoordinates, span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))
        mapScene.setRegion(region, animated: true)
    }
    
    //MARK: Setting Data
    
    //Function to fetch photos from DataCore, if it does not contain photos, download from flickr
    func fetchPhotos(){
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "location = %@", pin)
        if let results = try? dataController.viewContext.fetch(fetchRequest), results.count != 0 {
            //Set photos from data core
            photoAlbum = results
        } else {
            //Download photos from flickr
            fetchFlickrPhotos()
        }
    }
    
    //Function to download photo information from Flickr
    func fetchFlickrPhotos(){
        //Start progress animation
        progressIndicator.layer.cornerRadius = 5
        progressIndicator.startAnimating()
        //Check if coordinates are avaliable before procceding
        guard let coordinate = coordinate else {return}
        //Set total number of pages, default is 1 page
        let totalPages = pages
        ImageRetrieval.flickerAPI(coordinate.latitude, coordinate.longitude, totalPages) { (response, error) in
            if let response = response {
                print(response.photos.page)
                //Set total number of pages from response
                self.pages = response.photos.pages
                //Sen response to start downloading photos
                self.downloadPhotos(response)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    //Function to download photos from flickr using kingfisher
    func downloadPhotos(_ response : FlickrResponse){
        //Set photo array from reponse
        let imageArray = response.photos.photo
        //Loop over each photo to download
        for image in imageArray {
            let imageURL = URL(string: image.urlM)
            //Create image view to implment kingfisher function to download photo
            let imageView = UIImageView()
            imageView.kf.setImage(with: imageURL) { (result, error, cache, url) in
                if error == nil {
                    //Convert photo to type compatibile to core data model
                    let imageData = result!.pngData()!
                    self.storePhoto(imageData, url!)
                } else {
                    print(error)
                }
            }
        }
    }
    
    //MARK: Store Data
    
    //Function to Stroe images as binary data in Photo entity
    func storePhoto(_ photo: Data,_ url: URL){
        //Create photo context for core data Photo entity
        let photoContext = Photos(context: dataController.viewContext)
        photoContext.photoData = photo
        photoContext.photoURL = url
        photoContext.location = self.pin
        //Save photo context in core data
        try? dataController.viewContext.save()
        //Add element in array
        photoAlbum.append(photoContext)
        //Reload collection view to display new photo
        photoAlbumCollectionView.reloadData()
        //Stop progress animation
        progressIndicator.stopAnimating()
    }
    
    //MARK: Collection View Data Source

    //get number of photos to set number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbum.count
    }
    
    

    //Fill cells with photos from album
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoAlbumCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        let photoCell = photoAlbum[indexPath.row]
        //Set photo recieved
        cell.photo.kf.setImage(with: photoCell.photoURL)
        
        return cell
    }
    
    //TODO: tapped images are removed from collection view, photo album, and core data
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Get context of photo to be deleted
        let photoToDelete = photoAlbum[indexPath.row]
        //delete photo from core data
        dataController.viewContext.delete(photoToDelete)
        try? dataController.viewContext.save()
        //delete photo from array
        photoAlbum.remove(at: indexPath.row)
        //delete photo from collection view
        collectionView.deleteItems(at: [indexPath])
    }
    
    //TODO: "New Collection" button redownloads new images from other pages (use random value for "page" parameter)
    @IBAction func reloadPhotos(_ sender: Any) {
        //Fetch photos to be deleted where location is the current pin location
        let photosToDelete: NSFetchRequest<Photos> = Photos.fetchRequest()
        photosToDelete.predicate = NSPredicate(format: "location = %@", pin)
        //Once fetch is complete, loop over objects and delete one-by-one
        if let results = try? dataController.viewContext.fetch(photosToDelete), results.count != 0 {
            for photo in results {
                dataController.viewContext.delete(photo)
                //Once deleted last photo, remove all data from arrau and collection view, and refetch new photos
                if photo == results.last {
                    photoAlbum.removeAll()
                    photoAlbumCollectionView.reloadData()
                    fetchFlickrPhotos()
                }
            }
        } else {
            print("Error: no photos deleted")
        }
        try? dataController.viewContext.save()
        
    }
    

}
