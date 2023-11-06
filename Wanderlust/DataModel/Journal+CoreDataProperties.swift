//
//  Journal+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var journalText: String?
    @NSManaged public var journalLocation: String?
    @NSManaged public var journalPhoto: Data?
    @NSManaged public var journalTimeStamp: Date?
    @NSManaged public var trip: Trip?

}

extension Journal : Identifiable {

}
