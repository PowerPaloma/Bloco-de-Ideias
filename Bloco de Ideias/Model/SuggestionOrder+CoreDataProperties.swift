//
//  SuggestionOrder+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 21/06/2018.
//
//

import Foundation
import CoreData


extension SuggestionOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SuggestionOrder> {
        return NSFetchRequest<SuggestionOrder>(entityName: "SuggestionOrder")
    }

    @NSManaged public var order: Int64
    @NSManaged public var process: Process?
    @NSManaged public var suggestion: Suggestion?

}
