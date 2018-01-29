//
//  CardsSizeCalculator.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 29.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class CardsSizeCalculator {
    
    public let cardMaxWidth = 1024
    public let cardMaxHeight = 1024

    public var cardMaxSize: CGSize {
        return CGSize(width: CGFloat(cardMaxWidth), height: CGFloat(cardMaxHeight))
    }
    
    init() {
        
    }
    
    
    
}
