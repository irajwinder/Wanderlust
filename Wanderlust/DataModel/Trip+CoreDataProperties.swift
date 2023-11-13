//
//  Trip+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/13/23.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var tripCoverPhoto: String?
    @NSManaged public var tripEndDate: Date?
    @NSManaged public var tripName: String?
    @NSManaged public var tripStartDate: Date?
    @NSManaged public var journal: NSSet?
    @NSManaged public var photo: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for journal
extension Trip {

    @objc(addJournalObject:)
    @NSManaged public func addToJournal(_ value: Journal)

    @objc(removeJournalObject:)
    @NSManaged public func removeFromJournal(_ value: Journal)

    @objc(addJournal:)
    @NSManaged public func addToJournal(_ values: NSSet)

    @objc(removeJournal:)
    @NSManaged public func removeFromJournal(_ values: NSSet)

}

// MARK: Generated accessors for photo
extension Trip {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}

extension Trip : Identifiable {

}
