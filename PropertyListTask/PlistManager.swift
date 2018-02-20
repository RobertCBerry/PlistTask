//
//  PlistManager.swift
//  PropertyListTask
//
//  Created by Robert Berry on 2/19/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import Foundation

class PlistManager {
    
    // Retrieve the URL of the plist file.
    
    let plistUrl = Bundle.main.url(forResource: "Favorites", withExtension: "plist")
    
    // Retrieve reference to the FileManager.
    
    let fileManager = FileManager.default
    
    // Files included in the application bundle are read only, so in order to be able to add data to them, they first must be copied to the app's documents directory.
     
     // On app launch, we want to check if the file in the application bundle has been copied to the documents directory or not. If it has been copied before, we won't do anything. If not, then we'll copy it before attempting to write any new data.
     
     // documentsDirectoryFileURL returns the path for the documents directory we should be writing our plist file to and reading it from.
     
     func documentsDirectoryFileURL() -> URL? {
     
     do {
     
     let document = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
     
     let file = document.appendingPathComponent("Favorites.plist")
     
     return file
     
     } catch {
     
     print("Error getting file path.")
     
     return nil
     }
     }
     
     // fileExistsInDocumentsDirectory checks if the file at the path returned by documentsDirectoryFileURL exists or not, and returns a boolean.
     
     func fileExistsInDocumentsDirectory() -> Bool {
     
     if let file = documentsDirectoryFileURL() {
     
     let fileExists = FileManager().fileExists(atPath: file.path)
     
     return fileExists
     }
     
     return false
     }
     
    // seedDataToDocumentsDirectory copies the data from the file stored in the application bundle and writes it to the documents directory at the path provided by documentsDirectoryFileURL.
    
    func seedDataToDocumentsDirectory() {
        
        do {
            
            let plistData = try Data(contentsOf: plistUrl!)
            
            if let file = documentsDirectoryFileURL() {
                
                try plistData.write(to: file)
            }
            
        } catch {
            
            print("Error writing file.")
        }
    }
}
    
