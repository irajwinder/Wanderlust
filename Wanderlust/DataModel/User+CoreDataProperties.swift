//
//  User+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/3/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userEmail: String?
    @NSManaged public var userPassword: String?
    @NSManaged public var userFirstName: String?
    @NSManaged public var userLastName: String?
    @NSManaged public var userBio: String?

}

extension User : Identifiable {

}
