//
//  User+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 20/06/2018.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var credits: Int64
    @NSManaged public var desc: String?
    @NSManaged public var email: String?
    @NSManaged public var facebook: String?
    @NSManaged public var id: UUID?
    @NSManaged public var instagram: String?
    @NSManaged public var level: String?
    @NSManaged public var linkedin: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var pinterest: String?
    @NSManaged public var twitter: String?
    @NSManaged public var ideas: NSSet?

}

// MARK: Generated accessors for ideas
extension User {

    @objc(addIdeasObject:)
    @NSManaged public func addToIdeas(_ value: Idea)

    @objc(removeIdeasObject:)
    @NSManaged public func removeFromIdeas(_ value: Idea)

    @objc(addIdeas:)
    @NSManaged public func addToIdeas(_ values: NSSet)

    @objc(removeIdeas:)
    @NSManaged public func removeFromIdeas(_ values: NSSet)

}
