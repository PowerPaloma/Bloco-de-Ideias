//
//  Idea+CoreDataProperties.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 14/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//
//

import Foundation
import CoreData


extension Idea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Idea> {
        return NSFetchRequest<Idea>(entityName: "Idea")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var process: Process?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Idea {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Idea_Tag)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Idea_Tag)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
