//
//  FilterSettingsTableViewController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 21/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit

class FilterSettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    //Outlets properties
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var checkmarkCountry3: UIImageView!
    @IBOutlet weak var checkmarkRegion6: UIImageView!
    @IBOutlet weak var checkmarkCity11: UIImageView!
    
    
    //Data related properties
    var dataPickerSource: [String] = []
    
    //Setting Value properties
    var accuracyValue: String = ""
    var selectedTag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagPickerView.delegate = self
        tagPickerView.dataSource = self
        
        SetPickerViewData()
        setCheckmarkSelection()
    }
    
    // MARK: UI Setup
    
    func SetPickerViewData(){
        dataPickerSource = ["", "night", "ouside", "sea", "nature", "blue", "pet", "photography"]
        tagPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func setCheckmarkSelection(){
        checkmarkCountry3.isHidden = true
        checkmarkRegion6.isHidden = true
        checkmarkCity11.isHidden = true
    }

    // MARK: - Table view data source
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


