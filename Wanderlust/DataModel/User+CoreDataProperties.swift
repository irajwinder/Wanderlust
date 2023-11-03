//
//  User+CoreDataProperties.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/2/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userName: String?
    @NSManaged public var userPassword: String?

}

extension User : Identifiable {

}
