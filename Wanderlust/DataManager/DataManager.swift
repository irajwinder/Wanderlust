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
    
    func saveUser(userName: String, userEmail: String, userPassword: String, userDateOfBirth: Date, userProfilePhoto: String) {
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
        let fetchRequest = User.fetchRequest()
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
    
    func updateUser(user: User, userName: String, userEmail: String, userDateOfBirth: Date, profilePicticture: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext

        user.userName = userName
        user.userEmail = userEmail
        user.userDateOfBirth = userDateOfBirth
        user.userProfilePhoto = profilePicticture
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("User data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func saveTrip(user: User, tripName: String, tripStartDate: Date, tripEndDate: Date, tripCoverPhoto: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Trip entity in the context
        let trip = Trip(context: context)
        trip.setValue(user, forKey: "user")
        
        trip.tripName = tripName
        trip.tripStartDate = tripStartDate
        trip.tripEndDate = tripEndDate
        trip.tripCoverPhoto = tripCoverPhoto
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Trip data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveJournal(tripName: Trip, journalEntryText: String, journalEntryDate: Date, journalEntryPhoto: String, photoLatitude: Double, photoLongitude: Double) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Journal entity in the context
        let journal = Journal(context: context)
        journal.setValue(tripName, forKey: "trip")
        
        journal.journalEntryText = journalEntryText
        journal.journalEntryDate = journalEntryDate
        journal.journalEntryPhoto = journalEntryPhoto
        journal.photoLatitude = photoLatitude
        journal.photoLongitude = photoLongitude
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Journal data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func savePhoto(tripName: Trip, imageData: String, photoCaption: String, photoTag: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the photoGallery entity in the context
        let photoGallery = Photo(context: context)
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
    
    func deleteEntity(_ entity: NSManagedObject) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Remove the trip from the context
        context.delete(entity)

        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Trip deleted successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}

let dataManagerInstance = DataManager.sharedInstance
