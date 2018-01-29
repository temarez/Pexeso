//
//  CardsSizeCalculator.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 29.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class CardsSizeCalculator {
    
    public let cardSizeMax = CGSize(width: 1024, height: 1024)
    
    // public var collectionViewSize: CGSize
    
    public var cardSize: CGSize {
        return CGSize(width: 186, height: 186) // TODO: get rid of hard-coded values, calculate with collectionViewSize
    }
    
    init() {
        
    }
    
}
