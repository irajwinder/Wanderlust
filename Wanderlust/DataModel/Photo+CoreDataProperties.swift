//
//  Photo+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/13/23.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: String?
    @NSManaged public var photoTag: String?
    @NSManaged public var photoCaption: String?
    @NSManaged public var trip: Trip?

}

extension Photo : Identifiable {

}
