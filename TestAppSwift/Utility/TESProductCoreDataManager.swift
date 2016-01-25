//
//  TESProductCoreDataManager.swift
//  TestAppSwift
//
//  Created by Iegor Borodai on 7/23/15.
//  Copyright (c) 2015 Iegor Borodai. All rights reserved.
//

import UIKit
import CoreData

class TESProductCoreDataManager {
    
    private var products : [Product] = []
    var totalPrice : Int = 0
    var totalAmount : Int = 0
    var productsList : [Product] = []
    var productsBought : [Product] = []
    
    static let sharedInstance: TESProductCoreDataManager = TESProductCoreDataManager()
    
    init () {
        
        guard let managedContext = managedObjectContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest(entityName:"Product")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [Product]
            
            if let results = fetchedResults {
                if results.count > 0 {
                    products = results
                } else {
                    
                    let path = NSBundle.mainBundle().pathForResource("Products", ofType: "csv")
                    
                    let content = try String(contentsOfFile:path!, encoding: NSUTF8StringEncoding)
                    
                    let productsFromFile = content.componentsSeparatedByString("\n")
                    for product : String in productsFromFile {
                        
                        let productComponents = product.componentsSeparatedByString(",")
                        
                        if productComponents.count == 3 {
                            
                            let entity =  NSEntityDescription.entityForName("Product",
                                inManagedObjectContext:
                                managedContext)
                            
                            let productEntity = NSManagedObject(entity: entity!,
                                insertIntoManagedObjectContext:managedContext) as! TestAppSwift.Product
                            
                            productEntity.productName = productComponents[0]
                            
                            if let productAmount = Int(productComponents[1]) {
                                productEntity.productAmount = productAmount
                            }
                            
                            if let productPrice = Int(productComponents[2]) {
                                productEntity.productPrice = productPrice
                            }
                            
                            products.append(productEntity)
                        }
                        
                    }
                    
                    try managedContext.save()
                    
                }
                calculateTotals()
            }
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Public
    
    final func buyProduct (product : Product) {
        product.boughtAmount = product.boughtAmount.integerValue + 1
        product.productAmount = product.productAmount.integerValue - 1
        calculateTotals()
    }
    
    final func removeProduct (product : Product) {
        product.boughtAmount = product.boughtAmount.integerValue - 1
        product.productAmount = product.productAmount.integerValue + 1
        calculateTotals()
    }
    
    // MARK: - Core Data stack
    
    private func calculateTotals() {
        
        totalPrice = 0
        totalAmount = 0
        productsBought.removeAll(keepCapacity: false)
        productsList.removeAll(keepCapacity: false)
        for product in products {
            if product.boughtAmount.integerValue > 0 {
                totalAmount += product.boughtAmount.integerValue
                totalPrice += product.productPrice.integerValue * product.boughtAmount.integerValue
                productsBought.append(product)
            }
            if product.productAmount.integerValue > 0 {
                productsList.append(product)
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Products", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Products.sqlite")
        
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            do {
                if moc.hasChanges {
                    try moc.save()
                }
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
