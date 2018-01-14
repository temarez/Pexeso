//
//  CardCollectionViewCell.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 14.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardButton: UIButton!
    
    @IBAction func cardBtnClicked(_ sender: UIButton) {
        print("Card button clicked - from CardCollectionViewCell")
    }
}
