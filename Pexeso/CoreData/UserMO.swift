//
//  UserMO.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 01.02.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import Foundation
import CoreData

@objc(UserMO)
public class UserMO: NSManagedObject {

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var score: Int64
    
}
