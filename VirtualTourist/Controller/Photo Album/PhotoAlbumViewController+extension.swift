//
//  PhotoAlbumViewController+extension.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 20/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Collection View Data Source

extension PhotoAlbumViewController {
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
    
    //Function for tapped images are removed from collection view, photo album, and core data
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
}
