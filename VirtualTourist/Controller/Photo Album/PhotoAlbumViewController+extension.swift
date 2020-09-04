//
//  PhotoAlbumViewController+extension.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 20/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Collection View Data Source/Delegate

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

//MARK: - Picker View Data Source/Delegate

extension PhotoAlbumViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPickerSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPickerSource[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTag = dataPickerSource[row] as String
        tag = selectedTag
        //if no filter options is selected, then set total pages to 10. else if a filter is selected then set number of pages to one and disable the feature to reload a new collection
        if tag == "" {
            pages = 10
            setUIComponents(fiter: true, newCollection: true)
        } else {
            pages = 1
            setUIComponents(fiter: true, newCollection: false)
        }
        deleteAllandReload()
    }
}


