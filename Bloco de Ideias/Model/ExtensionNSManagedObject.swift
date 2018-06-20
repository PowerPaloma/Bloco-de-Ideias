//
//  ExtensionNSManagedObject.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 20/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func save(){
        let context:NSManagedObjectContext = DataManager.getContext()
        
        if (!self.isInserted) {
            context.insert(self)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving \(self.entity.description)")
        }
    }
    
    func delete(){
        let context:NSManagedObjectContext = DataManager.getContext()
        
        context.delete(self)
        
        do {
            try context.save()
        } catch let error as NSError{
            print("Error While Deleting: \(error.userInfo)")
        }
    }
}
