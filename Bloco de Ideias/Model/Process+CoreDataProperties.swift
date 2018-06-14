//
//  Process+CoreDataProperties.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 13/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//
//

import Foundation
import CoreData


extension Process {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Process> {
        return NSFetchRequest<Process>(entityName: "Process")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    
}
