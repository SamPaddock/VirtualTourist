//
//  TravelLocationMapViewController+extention.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 20/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit
import MapKit

//MARK: MapView Delegate functions

extension TravelLocationMapViewController {
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
            mapView.deselectAnnotation(view.annotation, animated: true)
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
}
