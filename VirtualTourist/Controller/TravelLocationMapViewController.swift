//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 23/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationMapViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    @IBOutlet weak var mapScene: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScene.delegate = self
        registerGestureLongTap()
    }
    
    //TODO: register a touch and hold gesture to add pin
    func registerGestureLongTap(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin))
        longPress.minimumPressDuration = 1
        longPress.delaysTouchesBegan = true
        self.mapScene.addGestureRecognizer(longPress)
    }
    
    @objc func addPin(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let selectedLocation = gestureRecognizer.location(in: self.mapScene)
            let coordination = self.mapScene.convert(selectedLocation, toCoordinateFrom: self.mapScene)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordination
            self.mapScene.addAnnotation(annotation)
        }
    }
    
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
    
    //TODO: added pins are presisted as Pin instance in CoreData and context is saved


}

