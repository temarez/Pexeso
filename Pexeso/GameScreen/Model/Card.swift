//
//  Card.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 09.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import Foundation

class Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return  identifierFactory
    }
    
    // TODO: Implement below "convertTo..." methods and later depending on selected database (in ) use one of these methods by means of switch construction in code:
    // func convertToRealmObject() -> Object { }
    // func convertToCoreDataObject() -> NSManagedObject { }
    // Here we may use "Abstract Factory" pattern

    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
