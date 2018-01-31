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
    
    private var image = [Int:String]()
    private var imageChoices: [String]
    
    init() {
        imageChoices = [String]()
        imageChoices.append("🦇")
        imageChoices.append("😱")
        imageChoices.append("🙀")
        imageChoices.append("😈")
        imageChoices.append("🎃")
        imageChoices.append("👻")
        imageChoices.append("🍭")
        imageChoices.append("🌍")
        imageChoices.append("🍎")
    }
    
    func image(for card: Card) -> String {
        if image[card.identifier] == nil, imageChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(imageChoices.count)))
            image[card.identifier] = imageChoices.remove(at: randomIndex)
        }
        
        return image[card.identifier] ?? imageBack()
    }
    
    func imageBack() -> String {
        return "BBB?"
    }
    
}
