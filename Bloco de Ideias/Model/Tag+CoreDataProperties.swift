//
//  Tag+CoreDataProperties.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Tag {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Idea_Tag)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Idea_Tag)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
