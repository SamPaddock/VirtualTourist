//
//  FilterSettingsTableViewController+extension.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 21/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIPicker View Delegates and Data Source

extension FilterSettingsTableViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPickerSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPickerSource[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTag = dataPickerSource[row] as String
    }
}

//MARK: TableView View Delegates and Data Source

extension FilterSettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let cell = tableView.cellForRow(at: indexPath)
        
        switch section {
        case 0:
            let cellIdentifier = (cell?.reuseIdentifier)! as String
            
            if cellIdentifier == "3" {
                accuracyValue = "3"
                showSelectedCheckmark(selected: checkmarkCountry3, deselected: (checkmarkRegion6, checkmarkCity11))
            } else if cellIdentifier == "6" {
                accuracyValue = "6"
                showSelectedCheckmark(selected: checkmarkRegion6, deselected: (checkmarkCountry3, checkmarkCity11))
            } else {
                accuracyValue = "11"
                showSelectedCheckmark(selected: checkmarkCity11, deselected: (checkmarkCountry3, checkmarkRegion6))
            }
        default:
            return
        }
    }
    
    func showSelectedCheckmark(selected checkmark: UIImageView, deselected checkmarks: (UIImageView,UIImageView)){
        checkmark.isHidden = false
        checkmarks.0.isHidden = true
        checkmarks.1.isHidden = true
    }
}
