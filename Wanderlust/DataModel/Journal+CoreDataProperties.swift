//
//  Journal+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/13/23.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var journalEntryPhoto: String?
    @NSManaged public var journalEntryText: String?
    @NSManaged public var photoLatitude: Double
    @NSManaged public var photoLongitude: Double
    @NSManaged public var journalEntryDate: Date?
    @NSManaged public var trip: Trip?

}

extension Journal : Identifiable {

}
