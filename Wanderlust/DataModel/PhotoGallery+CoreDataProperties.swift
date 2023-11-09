//
//  PhotoGallery+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/9/23.
//
//

import Foundation
import CoreData


extension PhotoGallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoGallery> {
        return NSFetchRequest<PhotoGallery>(entityName: "Photo")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var trip: Trip?

}

extension PhotoGallery : Identifiable {

}
