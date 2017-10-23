//
//  StateDAO.swift
//  LuizFrancisco_Douglas
//
//  Created by Luiz Zabuscka on 10/22/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import Foundation
import CoreData

class StateDAO {
    
    static func save(context: NSManagedObjectContext) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    static func list(context: NSManagedObjectContext) -> [StateMO] {
        do {
            return try context.fetch(StateMO.fetchRequest()) as! [StateMO]
        } catch {
            return []
        }
    }
    
    static func delete(context: NSManagedObjectContext, state: StateMO) -> Bool {
        do {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
            request.predicate = NSPredicate(format: "name = %@", state.name!)
            
            let states = try context.fetch(request) as! [StateMO]
            
            for state in states {
                context.delete(state)
                try context.save()
            }
            
            return true
        } catch {
            return false
        }
    }
    
    static func deleteAll(context: NSManagedObjectContext) -> Bool {
        do {
            
            let states = try context.fetch(StateMO.fetchRequest()) as! [StateMO]
            
            for state in states {
                context.delete(state)
                try context.save()
            }
            
            return true
        } catch {
            return false
        }
    }
    
}
