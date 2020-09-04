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

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{

    //MARK: properties
    //Outlet properties
    @IBOutlet weak var mapScene: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollectionBtn: UIBarButtonItem!
    @IBOutlet weak var filterOptionBtn: UIBarButtonItem!
    
    //Location properties
    var coordinate: CLLocationCoordinate2D? = nil
    var pin: Pin!
    
    //Data related properties
    var photoAlbum: [Photos] = []
    var photoResponse: FlickrResponse!
    var pages: Int = 10
    var dataPickerSource: [String] = []
    var accuracy: String = "11"
    var tag: String = ""
    
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
        //set UI Component enableility
        setUIComponents(fiter: true, newCollection: true)
        //Show location of photos
        placePinLocation()
        //Check if there are saved photos of that location
        fetchPhotos()
        //Populate pickerView
        SetPickerViewData()
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
    
    //Function with array of tags for pickerView data source
    func SetPickerViewData(){
        //Some tag values
        dataPickerSource = ["", "night", "ouside", "sea", "nature", "blue", "pet", "photography"]
    }
    
    //Function to change UI Component
    func setUIComponents(fiter isFilterEnabled: Bool, newCollection isNewCollectionEnabled: Bool){
        filterOptionBtn.isEnabled = isFilterEnabled
        newCollectionBtn.isEnabled = isNewCollectionEnabled
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
        ImageRetrieval.flickerAPI(coordinate.latitude, coordinate.longitude, totalPages, tag, accuracy) { (response, error, errorCode) in
            if let response = response {
                //Sen response to start downloading photos
                self.downloadPhotos(response)
            } else {
                print(error?.localizedDescription ?? "error")
                let alert = AlertMessage.errorAlert(Code: errorCode)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Function to download photos from flickr using kingfisher
    func downloadPhotos(_ response : FlickrResponse){
        guard response.photos.photo.count > 0 else {
            setUIComponents(fiter: false, newCollection: false)
            progressIndicator.stopAnimating()
            let alert = AlertMessage.errorAlert(Code: 204)
            self.present(alert, animated: true, completion: nil)
            return
        }
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
                    let alert = AlertMessage.errorAlert(Code: 418)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //Function to delete all photos and reload new photo collection
    func deleteAllandReload() {
        
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
        //refreshed the collection view layout when reloading data
        photoAlbumCollectionView.collectionViewLayout.invalidateLayout()
        //Stop progress animation
        progressIndicator.stopAnimating()
    }
    
    //MARK: Action: Toolbar Functions
    
    //"New Collection" button redownloads new images from other pages (use random value for "page" parameter)
    @IBAction func newCollectionReload(_ sender: Any) {
        deleteAllandReload()
    }
    
    //"Filter" button to filter through photos of the selected location by accuracy range or tag value
    @IBAction func filterPhotosTapped(_ sender: Any) {
        let filterSelection = UIAlertController(title: "Filter Options", message: nil, preferredStyle: .actionSheet)
        
        let accuracyOption = UIAlertAction.init(title: "Covergae Range", style: .default) { (alert) in
            self.accuracySelectionAlertAction()
        }
        filterSelection.addAction(accuracyOption)
        
        let tagOption = UIAlertAction.init(title: "Tags", style: .default) { (alert) in
            self.tagSelectionAlertAction()
        }
        filterSelection.addAction(tagOption)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        filterSelection.addAction(cancelAction)
        
        self.present(filterSelection, animated: true, completion: nil)
    }
    
    //MARK: ActionSheet: Filtering Photos
    
    //Function to present ction sheet with multipule range option for accuracy range
    func accuracySelectionAlertAction(){
        let accuracySelection = UIAlertController(title: "Covergae Range", message: "Retrieves photos from the selected coverage range", preferredStyle: .actionSheet)
        
        accuracySelection.addAction(alertActionSelection(title: "City"))
        accuracySelection.addAction(alertActionSelection(title: "Region"))
        accuracySelection.addAction(alertActionSelection(title: "Country"))
        
        let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        accuracySelection.addAction(okAction)
        
        self.present(accuracySelection, animated: true, completion: nil)
    }
    
    //Create alert action to return and be added to the alert
    func alertActionSelection(title range: String) -> UIAlertAction{
        return UIAlertAction(title: range, style: .default, handler: accuracySelectionHandler(_:))
    }
    
    //Function to present ction sheet with picker view of tag values
    func tagSelectionAlertAction(){
        let tagSelection = UIAlertController(title: "Tags", message: "Retrieves photos from the selected coverage range", preferredStyle: .actionSheet)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: tagSelection.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        tagSelection.view.addConstraint(height)
        
        let width = Int(tagSelection.view.bounds.width - 15)
        let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 50, width: width, height: 140))
        
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        tagSelection.view.addSubview(pickerFrame)
        
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        tagSelection.addAction(okAction)
        
        self.present(tagSelection, animated: true, completion: nil)
    }
    
    //MARK: Handler Functions
    
    //Function to handlw accuracy range selected
    func accuracySelectionHandler(_ alert: UIAlertAction){
        switch alert.title {
        case "City": accuracy = "11"
        case "Region": accuracy = "6"
        case "Country": accuracy = "3"
        default: accuracy = "11"
        }
        deleteAllandReload()
    }
    
}
