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


extension SuggestionStatus {
    convenience init(){
        let entity:NSEntityDescription = DataManager.getEntity(entity: "SuggestionStatus")
        let context:NSManagedObjectContext = DataManager.getContext()
        self.init(entity: entity, insertInto: context)
    }
    
    class func entityDescription() -> (NSEntityDescription){
        let entity:NSEntityDescription = DataManager.getEntity(entity: "SuggestionStatus")
        return entity
    }
}
