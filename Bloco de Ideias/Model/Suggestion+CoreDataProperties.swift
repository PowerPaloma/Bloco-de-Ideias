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
    @NSManaged public var topics: NSSet?

}

// MARK: Generated accessors for topics
extension Suggestion {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: Topic)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: Topic)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}
