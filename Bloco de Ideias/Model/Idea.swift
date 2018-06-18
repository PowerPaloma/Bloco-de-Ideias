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


extension Idea {
    
    //    @objc
    //    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    //        super.init(entity: entity, insertInto: context)
    //    }
    
    convenience init(){
        let entity:NSEntityDescription = DataManager.getEntity(entity: "Idea")
        let context:NSManagedObjectContext = DataManager.getContext()
        
        self.init(entity: entity, insertInto: context)
    }
    
    class func entityDescription() -> (NSEntityDescription){
        let entity:NSEntityDescription = DataManager.getEntity(entity: "Idea")
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
    
    func delete(){
        let context:NSManagedObjectContext = DataManager.getContext()

        
        context.delete(self)
        
        do {
            try context.save()
        } catch  let error as NSError{
            print("Error While Deleting Note: \(error.userInfo)")
        }
        
        let entity = DataManager.getEntity(entity: "Idea")
        let ideas = DataManager.getAll(entity: entity)
        
        if (ideas.success){
            if(ideas.objects.count == 0){
                NSLog("Não existem registros.")
            }else{
                for idea in ideas.objects as! [Idea] {
                    print(idea.title)
                }
            }
        }
               
    }
}
