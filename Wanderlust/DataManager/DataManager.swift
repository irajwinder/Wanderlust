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
        // Create a new instance of the User entity in the context
        let user = User(context: context)
        user.userName = userName
        user.userEmail = userEmail
        user.userPassword = userPassword
        user.userDateOfBirth = userDateOfBirth
        user.userProfilePhoto = userProfilePhoto
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("User data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveTrip(tripName: String, tripStartDate: Date, tripEndDate: Date, tripCoverPhoto: Data, tripLongitude: Double, tripLatitude: Double) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Trip entity in the context
        let trip = Trip(context: context)
        trip.tripName = tripName
        trip.tripStartDate = tripStartDate
        trip.tripEndDate = tripEndDate
        trip.tripCoverPhoto = tripCoverPhoto
        trip.tripLongitude = tripLongitude
        trip.tripLatitude = tripLatitude
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Trip data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveJournal(journalText: String, journalPhoto: Data, journalLocation: String, journalTimeStamp: Date) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Journal entity in the context
        let journal = Journal(context: context)
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
    
    func savePhoto(imageData: Data, photoCaption: String, photoTag: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the photoGallery entity in the context
        let photoGallery = PhotoGallery(context: context)
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
