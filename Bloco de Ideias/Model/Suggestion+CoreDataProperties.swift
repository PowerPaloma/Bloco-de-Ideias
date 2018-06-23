//
//  Suggestion+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 21/06/2018.
//
//

import Foundation
import CoreData


extension Suggestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Suggestion> {
        return NSFetchRequest<Suggestion>(entityName: "Suggestion")
    }

    @NSManaged public var descS: String?
    @NSManaged public var isText: Bool
    @NSManaged public var titleS: String?
    @NSManaged public var topicTitle: String?
    @NSManaged public var processes: NSSet?
    @NSManaged public var suggestionOrder: NSSet?
    @NSManaged public var suggestionStatus: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for processes
extension Suggestion {

    @objc(addProcessesObject:)
    @NSManaged public func addToProcesses(_ value: Process)

    @objc(removeProcessesObject:)
    @NSManaged public func removeFromProcesses(_ value: Process)

    @objc(addProcesses:)
    @NSManaged public func addToProcesses(_ values: NSSet)

    @objc(removeProcesses:)
    @NSManaged public func removeFromProcesses(_ values: NSSet)

}

// MARK: Generated accessors for suggestionOrder
extension Suggestion {

    @objc(addSuggestionOrderObject:)
    @NSManaged public func addToSuggestionOrder(_ value: SuggestionOrder)

    @objc(removeSuggestionOrderObject:)
    @NSManaged public func removeFromSuggestionOrder(_ value: SuggestionOrder)

    @objc(addSuggestionOrder:)
    @NSManaged public func addToSuggestionOrder(_ values: NSSet)

    @objc(removeSuggestionOrder:)
    @NSManaged public func removeFromSuggestionOrder(_ values: NSSet)

}

// MARK: Generated accessors for suggestionStatus
extension Suggestion {

    @objc(addSuggestionStatusObject:)
    @NSManaged public func addToSuggestionStatus(_ value: SuggestionStatus)

    @objc(removeSuggestionStatusObject:)
    @NSManaged public func removeFromSuggestionStatus(_ value: SuggestionStatus)

    @objc(addSuggestionStatus:)
    @NSManaged public func addToSuggestionStatus(_ values: NSSet)

    @objc(removeSuggestionStatus:)
    @NSManaged public func removeFromSuggestionStatus(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Suggestion {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
