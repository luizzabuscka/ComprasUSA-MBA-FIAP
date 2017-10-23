//
//  ProductDAO.swift
//  LuizFrancisco_Douglas
//
//  Created by Luiz Zabuscka on 10/22/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import Foundation
import CoreData

class ProductDAO {
    
    static func save(context: NSManagedObjectContext) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    static func list(context: NSManagedObjectContext) -> [ProductMO] {
        do {
            return try context.fetch(ProductMO.fetchRequest()) as! [ProductMO]
        } catch {
            return []
        }
    }
    
    static func delete(context: NSManagedObjectContext, product: ProductMO) -> Bool {
        do {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            request.predicate = NSPredicate(format: "name = %@", product.name!)
            
            let products = try context.fetch(request) as! [ProductMO]
            
            for product in products {
                context.delete(product)
                try context.save()
            }
            
            return true
        } catch {
            return false
        }
    }
    
    static func deleteAll(context: NSManagedObjectContext) -> Bool {
        do {
            
            let products = try context.fetch(ProductMO.fetchRequest()) as! [ProductMO]
            
            for product in products {
                context.delete(product)
                try context.save()
            }
            
            return true
        } catch {
            return false
        }
    }
    
}
