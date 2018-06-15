//
//  Process+CoreDataClass.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 13/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//
//

import Foundation
import CoreData


extension Process {
    
//    @objc
//    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
//        super.init(entity: entity, insertInto: context)
//    }
    
    convenience init(){
        let entity:NSEntityDescription = DataManager.getEntity(entity: "Process")
        let context:NSManagedObjectContext = DataManager.getContext()
        self.init(entity: entity, insertInto: context)
    }
    
    class func entityDescription() -> (NSEntityDescription){
        let entity:NSEntityDescription = DataManager.getEntity(entity: "Process")
        return entity
    }
    
    func save(){
        let context:NSManagedObjectContext = DataManager.getContext()
        
        if (!self.isInserted) {
            context.insert(self)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}
