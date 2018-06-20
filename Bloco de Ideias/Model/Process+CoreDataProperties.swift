//
//  Process+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 20/06/2018.
//
//

import Foundation
import CoreData


extension Process {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Process> {
        return NSFetchRequest<Process>(entityName: "Process")
    }

    @NSManaged public var name: String?

}
