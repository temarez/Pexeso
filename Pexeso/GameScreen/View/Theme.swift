//
//  Theme.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 29.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class Theme {
    var name = "default"
    
    private var image = [Int:UIImage]()
    private var imageChoices: [UIImage]
    
    init() {
        imageChoices = [UIImage]()
        imageChoices.append(#imageLiteral(resourceName: "i01"))
        imageChoices.append(#imageLiteral(resourceName: "i02"))
        imageChoices.append(#imageLiteral(resourceName: "i03"))
        imageChoices.append(#imageLiteral(resourceName: "i04"))
        imageChoices.append(#imageLiteral(resourceName: "i05"))
        imageChoices.append(#imageLiteral(resourceName: "i06"))
        imageChoices.append(#imageLiteral(resourceName: "i07"))
        imageChoices.append(#imageLiteral(resourceName: "i08"))
        imageChoices.append(#imageLiteral(resourceName: "i09"))
        imageChoices.append(#imageLiteral(resourceName: "i10"))
        imageChoices.append(#imageLiteral(resourceName: "i11"))
        imageChoices.append(#imageLiteral(resourceName: "i12"))
        imageChoices.append(#imageLiteral(resourceName: "i13"))
        imageChoices.append(#imageLiteral(resourceName: "i14"))
        imageChoices.append(#imageLiteral(resourceName: "i15"))
        imageChoices.append(#imageLiteral(resourceName: "i16"))
        imageChoices.append(#imageLiteral(resourceName: "i17"))
        imageChoices.append(#imageLiteral(resourceName: "i18"))
        imageChoices.append(#imageLiteral(resourceName: "i19"))
        imageChoices.append(#imageLiteral(resourceName: "i20"))
    }
    
    func image(for card: Card) -> UIImage {
        if image[card.identifier] == nil, imageChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(imageChoices.count)))
            image[card.identifier] = imageChoices.remove(at: randomIndex)
        }
        
        return image[card.identifier] ?? imageBack()
    }
    
    func imageBack() -> UIImage {
        return #imageLiteral(resourceName: "back")
    }
    
}
