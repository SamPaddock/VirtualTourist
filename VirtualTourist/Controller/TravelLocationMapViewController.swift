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
    @IBOutlet weak var mapScene: MKMapView!
    
    var dataController: DataController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    
    var pins: [Pin] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScene.delegate = self
        
        loadPinLocation()
        registerGestureLongTap()
        
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
    
    //MARK: Navigation: selected location
    
    //TODO: Tapped pin, transitions to photo album interface (with, tapped location)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let coordinate = view.annotation?.coordinate {
                let photoAlbumVC = storyboard?.instantiateViewController(identifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
                photoAlbumVC.coordinate = coordinate
                self.present(photoAlbumVC, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Save/Load pin location to/from Core Data
    
    //TODO: added pins are presisted as Pin instance in CoreData and context is saved
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
    
    func loadPinLocation(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            pins = results
        }
    }


}

