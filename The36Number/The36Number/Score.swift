//
//  Score.swift
//  The36Number
//
//  Created by Nantinee Tulyanon on 11/30/14.
//  Copyright (c) 2014 mabaw. All rights reserved.
//

import Foundation
import CoreData

class Score: NSManagedObject {
    @NSManaged var level: Int16
    @NSManaged var score: Float
}