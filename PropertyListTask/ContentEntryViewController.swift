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
    
    @IBOutlet weak var showButton: UIBarButtonItem!
    
    let plistManager = PlistManager()
    
    // favorite stores the data we read and allows us to append it.
    
    var favorites: [String]?
    
    @IBOutlet weak var favoriteFoodTextView: UITextView!
    
    @IBOutlet weak var favoriteMovieTextView: UITextView!
    
    @IBOutlet weak var favoriteBookTextView: UITextView!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Code states that the property list is in the xml format.
        
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            
            // plistData contains the contents of the documents directory which should include Favorites.plist.
            
            let plistData = try Data(contentsOf: plistManager.documentsDirectoryFileURL()!)
            
            // Retrieves property list data and casts to dictionary with String and Any Key-Value pairs.
            
            if var favorites = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as? [String: Any] {
            
                let favFood = favoriteFoodTextView.text as String
                let favMovie = favoriteMovieTextView.text as String
                let favBook = favoriteBookTextView.text as String
                
                // Appends strings to favorites array in property list. 
                
                favorites["favFood"] = favFood
                favorites["favMovie"] = favMovie
                favorites["favBook"] = favBook
                
                for _ in favorites {
                    print("Favorite Food: \(String(describing: favFood)), Favorite Movie: \(String(describing: favMovie)), Favorite Book: \(String(describing: favBook))")
                } 
                
                // Turns favorites array into data object containing the property list and the specified format of the property list, which in this case is XML.
                
                let serializedData = try PropertyListSerialization.data(fromPropertyList: favorites, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
                
                if let file = plistManager.documentsDirectoryFileURL() {
                    
                    try serializedData.write(to: file)
                    print("The file path is \(file).")
                }
            }
        
        } catch { 
            
            print("Error")
        }
        
        showButton.isEnabled = true 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Conditional checks on each app launch whether the plist file exists at the documents directory and copies the file data from the application bundle to the documents directory if that is not the case.
        
        // In order for this to work on each app launch the app must be removed from the project's simulator and the project cleaned.
        
        if plistManager.fileExistsInDocumentsDirectory() == false {
            
            plistManager.seedDataToDocumentsDirectory()
            print("Favorites.plist has been added to the documents directory.")
        }
        
        showButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
} 

