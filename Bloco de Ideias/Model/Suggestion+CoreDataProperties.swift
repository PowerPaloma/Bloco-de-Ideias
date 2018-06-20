//
//  Suggestion+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 20/06/2018.
//
//

import Foundation
import CoreData


extension Suggestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Suggestion> {
        return NSFetchRequest<Suggestion>(entityName: "Suggestion")
    }

    @NSManaged public var descS: String?
    @NSManaged public var titleS: String?
    @NSManaged public var process: Process?

}
