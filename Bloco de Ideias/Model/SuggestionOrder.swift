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


extension SuggestionOrder {
    convenience init(){
        self.init(entity: DataManager.getEntity(entity: "SuggestionOrder"), insertInto: nil)
    }
    
    class func entityDescription() -> (NSEntityDescription){
        return DataManager.getEntity(entity: "SuggestionOrder")
    }
}
