//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 23/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

    //MARK: properties
    @IBOutlet weak var mapScene: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    
    
    //TODO: If pin tapped, does not contain photos, download from flickr
    
    //TODO: If pin tapped, does have images, no download needed
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //TODO: Stroe images an binary data ib Photo entity (Allow External storage)
    
    //TODO: tapped images are removed from collection view, photo album, and core data
    
    //TODO: "New Collection" button redownloads new images from other pages (use random value for "page" parameter)


}
