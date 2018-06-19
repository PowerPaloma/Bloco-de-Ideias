//
//  DataManager.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 11/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class DataManager {

    class func getEntity(entity: String) -> (NSEntityDescription){
        let context:NSManagedObjectContext = DataManager.getContext()
        
        let description:NSEntityDescription = NSEntityDescription.entity(forEntityName: entity, in: context)!
        
        return description
    }
    
    class func getContext () -> (NSManagedObjectContext) {
        let delegate = (UIApplication.shared).delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    class func getAll(entity: NSEntityDescription) -> (success: Bool, objects: [NSManagedObject]){
        let context:NSManagedObjectContext = DataManager.getContext()
        
        let request:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        
        var result:[NSManagedObject]?
        
        do {
            result = try context.fetch(request) as? [NSManagedObject]
            return(true, result!)
        } catch {
            print("Failed reading all")
            return(false, result!)
        }
    }
    
    class func deleteAll(entity: NSEntityDescription) {
        let context = DataManager.getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error on deleting all")
        }
    }
}
