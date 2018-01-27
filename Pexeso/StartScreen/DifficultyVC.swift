//
//  DifficultyVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 10.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

protocol NumOfPairsPickerDelegate {
    func getPickerViewSelectedNumOfPairs() -> Int
}

class DifficultyVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NumOfPairsPickerDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pairsLabel: UILabel!
    
    // I assume that the maximal possible number of pairs is 12 (24 cards) since minimal iPhone screen (320x480) may fit about 4x6 cards (in this case each card size will be 80x80 maximum)
    let availableNumOfPairs = [Int](1...12)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: availableNumOfPairs[row])
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
        if let destination = segue.destination as? GameVC {
            destination.delegate = self
        }
    }
    
    func getPickerViewSelectedNumOfPairs() -> Int {
        let pickerSelectedRow = pickerView.selectedRow(inComponent: 0)
        var selectedNumOfPairs = 0
        if pickerSelectedRow != -1 {
            selectedNumOfPairs = availableNumOfPairs[pickerSelectedRow]
        }
        return selectedNumOfPairs
    }
    
    @IBAction func highScoresPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "DifficultyVC2HighScoresVC", sender: nil)
    }
    
    
}