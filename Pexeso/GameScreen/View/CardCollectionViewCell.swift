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
    var isOpen = false
    
    @IBAction func cardBtnClicked(_ sender: UIButton) {
        let cardView = CardView()
        //print("Card button clicked - from CardCollectionViewCell")
        if isOpen {
            isOpen = false
            let image = UIImage(named: "back")
            cardButton.setImage(image, for: .normal)
            cardView.cardCloseAnimation(view: cardButton)
            cardView.cardsMatchAnimation(view: cardButton)
        } else {
            isOpen = true
            let image = UIImage(named: "i01")
            cardButton.setImage(image, for: .normal)
            cardView.cardOpenAnimation(view: cardButton)
        }
    }
}