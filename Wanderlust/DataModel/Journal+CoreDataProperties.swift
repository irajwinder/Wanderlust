//
//  Journal+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/9/23.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var journalPhoto: Data?
    @NSManaged public var journalText: String?
    @NSManaged public var photoTimeStamp: Date?
    @NSManaged public var photoLatitude: Double
    @NSManaged public var photoLongitude: Double
    @NSManaged public var photoTag: String?
    @NSManaged public var photoCaption: String?
    @NSManaged public var trip: Trip?

}

extension Journal : Identifiable {

}
