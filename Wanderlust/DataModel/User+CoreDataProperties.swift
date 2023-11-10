//
//  User+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/10/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userDateOfBirth: Date?
    @NSManaged public var userEmail: String?
    @NSManaged public var userName: String?
    @NSManaged public var userPassword: String?
    @NSManaged public var userProfilePhoto: String?
    @NSManaged public var trip: NSSet?

}

// MARK: Generated accessors for trip
extension User {

    @objc(addTripObject:)
    @NSManaged public func addToTrip(_ value: Trip)

    @objc(removeTripObject:)
    @NSManaged public func removeFromTrip(_ value: Trip)

    @objc(addTrip:)
    @NSManaged public func addToTrip(_ values: NSSet)

    @objc(removeTrip:)
    @NSManaged public func removeFromTrip(_ values: NSSet)

}

extension User : Identifiable {

}
