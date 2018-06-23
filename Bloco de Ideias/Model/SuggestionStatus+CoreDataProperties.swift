//
//  SuggestionStatus+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 21/06/2018.
//
//

import Foundation
import CoreData


extension SuggestionStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SuggestionStatus> {
        return NSFetchRequest<SuggestionStatus>(entityName: "SuggestionStatus")
    }

    @NSManaged public var done: Bool
    @NSManaged public var idea: Idea?
    @NSManaged public var suggestion: Suggestion?

}
