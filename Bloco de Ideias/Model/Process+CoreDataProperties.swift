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
    @NSManaged public var ideas: NSSet?
    @NSManaged public var suggestions: NSSet?

}

// MARK: Generated accessors for ideas
extension Process {

    @objc(addIdeasObject:)
    @NSManaged public func addToIdeas(_ value: Idea)

    @objc(removeIdeasObject:)
    @NSManaged public func removeFromIdeas(_ value: Idea)

    @objc(addIdeas:)
    @NSManaged public func addToIdeas(_ values: NSSet)

    @objc(removeIdeas:)
    @NSManaged public func removeFromIdeas(_ values: NSSet)

}

// MARK: Generated accessors for suggestions
extension Process {

    @objc(addSuggestionsObject:)
    @NSManaged public func addToSuggestions(_ value: Suggestion)

    @objc(removeSuggestionsObject:)
    @NSManaged public func removeFromSuggestions(_ value: Suggestion)

    @objc(addSuggestions:)
    @NSManaged public func addToSuggestions(_ values: NSSet)

    @objc(removeSuggestions:)
    @NSManaged public func removeFromSuggestions(_ values: NSSet)

}
