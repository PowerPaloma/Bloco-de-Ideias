//
//  Idea+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 21/06/2018.
//
//

import Foundation
import CoreData


extension Idea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Idea> {
        return NSFetchRequest<Idea>(entityName: "Idea")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var process: Process?
    @NSManaged public var tags: NSSet?
    @NSManaged public var topics: NSSet?
    @NSManaged public var user: User?
    @NSManaged public var suggestionStatus: NSSet?

}

// MARK: Generated accessors for tags
extension Idea {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for topics
extension Idea {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: Topic)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: Topic)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}

// MARK: Generated accessors for suggestionStatus
extension Idea {

    @objc(addSuggestionStatusObject:)
    @NSManaged public func addToSuggestionStatus(_ value: SuggestionStatus)

    @objc(removeSuggestionStatusObject:)
    @NSManaged public func removeFromSuggestionStatus(_ value: SuggestionStatus)

    @objc(addSuggestionStatus:)
    @NSManaged public func addToSuggestionStatus(_ values: NSSet)

    @objc(removeSuggestionStatus:)
    @NSManaged public func removeFromSuggestionStatus(_ values: NSSet)

}
