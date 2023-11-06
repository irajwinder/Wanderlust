//
//  Location+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
    @NSManaged public var locationTimeStamp: Date?
    @NSManaged public var locationName: String?
    @NSManaged public var trip: Trip?

}

extension Location : Identifiable {

}
