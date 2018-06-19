//
//  Process+CoreDataProperties.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 19/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
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
