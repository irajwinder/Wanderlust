//
//  PhotoGallery+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//
//

import Foundation
import CoreData


extension PhotoGallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoGallery> {
        return NSFetchRequest<PhotoGallery>(entityName: "Photo")
    }

    @NSManaged public var photoCaption: String?
    @NSManaged public var photoTag: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var trip: Trip?

}

extension PhotoGallery : Identifiable {

}
