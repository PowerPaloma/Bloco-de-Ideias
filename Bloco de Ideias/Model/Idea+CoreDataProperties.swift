//
//  Idea+CoreDataProperties.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 19/06/2018.
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
    @NSManaged public var tag: NSSet?

}

// MARK: Generated accessors for tag
extension Idea {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}
