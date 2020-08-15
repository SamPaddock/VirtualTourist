//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 23/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationMapViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    //Outlet properties
    @IBOutlet weak var mapScene: MKMapView!
    
    //DataController property
    var dataController: DataController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    
   //Data related properties
    var pins: [Pin] = []
    var mapLocation: [String: Double] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate views to self
        mapScene.delegate = self
        //Load saved pins on map
        loadPinLocation()
        //Register gestures to map
        registerGestureLongTap()
    }
    
    
    //When view will appear, set last set location and zoom level
    override func viewWillAppear(_ animated: Bool) {
        if let mapLocation = UserDefaults.standard.object(forKey: "mapLocation") {
            let mapLocationSetter = mapLocation as! [String:Double]
            
            let latSpan = CLLocationDegrees(mapLocationSetter["regionLat"]!)
            let lonSpan = CLLocationDegrees(mapLocationSetter["regionLon"]!)
            let mapSpan = MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
            
            let latCenter = CLLocationDegrees(mapLocationSetter["centerLat"]!)
            let lonCenter = CLLocationDegrees(mapLocationSetter["centerLon"]!)
            let mapCenter = CLLocationCoordinate2D(latitude: latCenter, longitude: lonCenter)
            
            mapScene.region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        }
    }
    
    //MARK: Gesture Recognition and Action
    
    //Function to register a touch and hold gesture to add pin
    func registerGestureLongTap(){
        //Creat gesture recognizer for long press to add pin
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin))
        longPress.minimumPressDuration = 1
        longPress.delaysTouchesBegan = true
        self.mapScene.addGestureRecognizer(longPress)
    }
    
    //Function to add a pin on the map after recognizing a long press
    @objc func addPin(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            //Get the coordinates where user tapped
            let selectedLocation = gestureRecognizer.location(in: self.mapScene)
            let coordination = self.mapScene.convert(selectedLocation, toCoordinateFrom: self.mapScene)
            //Save tapped location
            savePinLocation(coordinate: coordination)
        }
    }
    
    //MARK: MapView Delegate functions
    
    //Creat pin to add on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var mapPin = mapScene.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if mapPin == nil {
            mapPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            mapPin?.canShowCallout = true
            mapPin?.rightCalloutAccessoryView = UIButton(type: .infoDark)
        }
        
        return mapPin
    }
    
    //Function for tapped pin, transitions to photo album interface (with, tapped location)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            let photoAlbumVC = storyboard?.instantiateViewController(identifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
            
            let lat = Double(coordinate.latitude)
            let lon = Double(coordinate.longitude)
            for pin in pins {
                if pin.latitude == lat && pin.longitude == lon {
                    photoAlbumVC.pin = pin
                }
            }
            photoAlbumVC.coordinate = coordinate
            self.present(photoAlbumVC, animated: true, completion: nil)
        }
    }
    
    //Function to save last set location and zoom level
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapLocation["regionLat"] = Double(mapView.region.span.latitudeDelta)
        mapLocation["regionLon"] = Double(mapView.region.span.longitudeDelta)
        mapLocation["centerLat"] = Double(mapView.region.center.latitude)
        mapLocation["centerLon"] = Double(mapView.region.center.longitude)
        UserDefaults.standard.set(mapLocation, forKey: "mapLocation")
    }
    
    //MARK: Load Pins On Map
    
    func LoadPinsOnMap(pins: [Pin]){
        guard pins.count != 0 else {return}
        
        //creat a map annotations array
        var mapAnnotation = [MKPointAnnotation]()
        
        for pin in pins {
            //create a map annotation
            let annotation = MKPointAnnotation()
            let coordination = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.coordinate = coordination
            mapAnnotation.append(annotation)
        }
        
        //remove current annotation and add new annotations
        mapScene.removeAnnotations(mapScene.annotations)
        mapScene.addAnnotations(mapAnnotation)
        
    }
    
    //MARK: Save/Load pin location to/from Core Data
    
    //Function to added pins are presisted as Pin instance in CoreData and context is saved
    func savePinLocation(coordinate: CLLocationCoordinate2D){
        //Save location in coreData
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        try? dataController.viewContext.save()
        //Add pin to pins array
        pins.append(pin)
        //Creat anootation to place pin where user tapped
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapScene.addAnnotation(annotation)
    }
    
    //Function to fetch all pins from Core data
    func loadPinLocation(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            pins = results
            LoadPinsOnMap(pins: results)
        }
    }
}

