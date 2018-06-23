//
//  Tag+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 21/06/2018.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var ideas: NSSet?
    @NSManaged public var suggestions: NSSet?

}

// MARK: Generated accessors for ideas
extension Tag {

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
extension Tag {

    @objc(addSuggestionsObject:)
    @NSManaged public func addToSuggestions(_ value: Suggestion)

    @objc(removeSuggestionsObject:)
    @NSManaged public func removeFromSuggestions(_ value: Suggestion)

    @objc(addSuggestions:)
    @NSManaged public func addToSuggestions(_ values: NSSet)

    @objc(removeSuggestions:)
    @NSManaged public func removeFromSuggestions(_ values: NSSet)

}
