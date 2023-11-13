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

    @NSManaged public var journalPhoto: String?
    @NSManaged public var journalText: String?
    @NSManaged public var photoLatitude: Double
    @NSManaged public var photoLongitude: Double
    @NSManaged public var photoTimeStamp: Date?
    @NSManaged public var trip: Trip?

}

extension Journal : Identifiable {

}
