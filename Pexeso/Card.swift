//
//  Card.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 09.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return  identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
