//
//  ScoreMO.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 01.02.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import Foundation
import CoreData

@objc(ScoreMO)
public class ScoreMO: NSManagedObject {

    @NSManaged public var name: String?
    @NSManaged public var cardsPairsNumber: Int64
    @NSManaged public var score: Int64
    
}
