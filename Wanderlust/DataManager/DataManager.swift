//
//  DataManager.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/3/23.
//

import UIKit
import CoreData

//Singleton Class
class DataManager: NSObject {
    
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
   
    private override init() {
        super.init()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Wanderlust")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    func saveUser(userName: String, userEmail: String, userPassword: String, userDateOfBirth: Date, userProfilePhoto: Data) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext

        if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let user = NSManagedObject(entity: entity, insertInto: context)
            user.setValue(userName, forKey: "userName")
            user.setValue(userEmail, forKey: "userEmail")
            user.setValue(userPassword, forKey: "userPassword")
            user.setValue(userDateOfBirth, forKey: "userDateOfBirth")
            user.setValue(userProfilePhoto, forKey: "userProfilePhoto")
        }
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("User data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchUser(userEmail: String) -> User? {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            // Fetch the User based on the fetch request
            let users = try context.fetch(fetchRequest)
            return users.first // Return the first user found
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func saveTrip(tripName: String, tripStartDate: Date, tripEndDate: Date, tripCoverPhoto: Data, tripLongitude: Double, tripLatitude: Double) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Trip", in: context) {
            let trip = NSManagedObject(entity: entity, insertInto: context)
            trip.setValue(tripName, forKey: "tripName")
            trip.setValue(tripStartDate, forKey: "tripStartDate")
            trip.setValue(tripEndDate, forKey: "tripEndDate")
            trip.setValue(tripCoverPhoto, forKey: "tripCoverPhoto")
            trip.setValue(tripLongitude, forKey: "tripLongitude")
            trip.setValue(tripLatitude, forKey: "tripLatitude")
        }
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Trip data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveJournal(tripName: Trip, journalText: String, journalPhoto: Data, journalLocation: String, journalTimeStamp: Date) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Journal entity in the context
        let journal = Journal(context: context)
        journal.setValue(tripName, forKey: "trip")
        journal.journalText = journalText
        journal.journalPhoto = journalPhoto
        journal.journalLocation = journalLocation
        journal.journalTimeStamp = journalTimeStamp
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Journal data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func savePhoto(tripName: Trip, imageData: Data, photoCaption: String, photoTag: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the photoGallery entity in the context
        let photoGallery = PhotoGallery(context: context)
        photoGallery.setValue(tripName, forKey: "trip")
        photoGallery.imageData = imageData
        photoGallery.photoCaption = photoCaption
        photoGallery.photoTag = photoTag
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Photo data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

let dataManagerInstance = DataManager.sharedInstance
