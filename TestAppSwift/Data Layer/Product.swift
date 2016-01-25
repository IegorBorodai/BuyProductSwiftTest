//
//  Product.swift
//  TestAppSwift
//
//  Created by Iegor Borodai on 7/23/15.
//  Copyright (c) 2015 Iegor Borodai. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject {

    @NSManaged var productName: String
    @NSManaged var productAmount: NSNumber
    @NSManaged var productPrice: NSNumber
    @NSManaged var boughtAmount: NSNumber
}
