//
//  FileManagerClass.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/14/23.
//

import Foundation
import SwiftUI

//Singleton Class
class FileManagerClass: NSObject {
    
    static let sharedInstance: FileManagerClass = {
        let instance = FileManagerClass()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func saveImageToFileManager(_ uiImage: UIImage, folderName: String, fileName: String) -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        //UUID for trip and photo
        let relativeURL  = "\(folderName)/\(fileName)"
        
        do {
            // Get the documents directory URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(relativeURL)
            
            // Create the necessary directory structure if it doesn't exist
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            
            // Write the image data to the file at the specified URL
            try imageData.write(to: fileURL)
            print("Image Location: \(fileURL)")
            return relativeURL
            
        } catch {
            // Print an error message if any issues occur during the image-saving process
            print("Error saving image:", error.localizedDescription)
            return nil
        }
    }
    
}

let fileManagerClassInstance = FileManagerClass.sharedInstance
