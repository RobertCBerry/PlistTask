//
//  ContentEntryViewController.swift
//  PropertyListTask
//
//  Created by Robert Berry on 2/8/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit

class ContentEntryViewController: UIViewController {
    
    // MARK: Properties
    
    // Retrieve the URL of the plist file.
    
    let plistUrl = Bundle.main.url(forResource: "Favorites", withExtension: "plist")
    
    // Retrieve reference to the FileManager.
    
    let fileManager = FileManager.default
    
    // favorite stores the data we read and allows us to append it.
    
    var favorite: [String]?
    
    @IBOutlet weak var favoriteFoodTextView: UITextView!
    
    @IBOutlet weak var favoriteMovieTextView: UITextView!
    
    @IBOutlet weak var favoriteBookTextView: UITextView!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            
            let plistData = try Data(contentsOf: documentsDirectoryFileURL()!)
            
            favorite = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as? [String]
            
            if var favorite = favorite {
                
                for _ in favorite {
                    print("Favorite Food: \(String(describing: favoriteFoodTextView.text)), Favorite Movie: \(String(describing: favoriteMovieTextView.text)), Favorite Book: \(String(describing: favoriteBookTextView.text))")
                }
                
                let favFood = favoriteFoodTextView.text as String
                let favMovie = favoriteMovieTextView.text as String
                let favBook = favoriteBookTextView.text as String
                
                favorite.append(favFood)
                favorite.append(favMovie)
                favorite.append(favBook)
                
                let serializedData = try PropertyListSerialization.data(fromPropertyList: favorite, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
                
                if let file = documentsDirectoryFileURL() {
                    
                    try serializedData.write(to: file)
                    print("The file path is \(file).")
                }
            }
        } catch {
            
            print("Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Conditional checks on each app launch whether the plist file exists at the documents directory and copies the file data from the application bundle to the documents directory if that is not the case.
        
        if fileExistsInDocumentsDirectory() == false {
            
            seedDataToDocumentsDirectory()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

