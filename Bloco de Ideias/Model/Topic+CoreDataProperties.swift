//
//  Topic+CoreDataProperties.swift
//  
//
//  Created by Ada 2018 on 20/06/2018.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var titleT: String?
    @NSManaged public var imageT: Data?
    @NSManaged public var descT: String?
    @NSManaged public var typeT: String?
    @NSManaged public var drawT: Data?
    @NSManaged public var idea: Idea?
    @NSManaged public var suggestion: Suggestion?

}
