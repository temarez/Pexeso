//
//  DifficultyVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 10.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

protocol NumOfPairsPickerDelegate {
    func getPickerViewSelectedRow() -> String
}

class DifficultyVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NumOfPairsPickerDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pairsLabel: UILabel!
    
    let availableNumOfPairs = ["2", "4", "6", "8", "10", "12"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return availableNumOfPairs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableNumOfPairs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pairsLabel.text = "Pairs: \(availableNumOfPairs[row])"
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "VCDifficultyToVCGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameUICollectionVC {
            destination.delegate = self
        }
    }
    
    func getPickerViewSelectedRow() -> String {
        let pickerSelectedRow = pickerView.selectedRow(inComponent: 0)
        if pickerSelectedRow != -1 {
            return availableNumOfPairs[pickerSelectedRow]
        } else {
            return "-1"
        }
    }
    
}
