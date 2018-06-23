//
//  Suggestion.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 21/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation
import CoreData


extension Suggestion {
    convenience init(){
        self.init(entity: DataManager.getEntity(entity: "Suggestion"), insertInto: nil)
    }
    
    class func entityDescription() -> (NSEntityDescription){
        return DataManager.getEntity(entity: "Suggestion")
    }
}
