//
//  SavedContentViewController.swift
//  PropertyListTask
//
//  Created by Robert Berry on 2/15/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit

class SavedContentViewController: UIViewController {
    
    // MARK: Properties
    
    let plistManager = PlistManager()
    
    @IBOutlet weak var savedFoodTextView: UITextView!
    
    @IBOutlet weak var savedMovieTextView: UITextView!
  
    @IBOutlet weak var savedBookTextView: UITextView!
    
    // Function that will be called in the viewDidLoad to set the properties for the class according to the property list.

    func readPropertyList() {
        
        // Code states that the property list is in the xml format.
        
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            
            // plistData contains the contents of the documents directory which should include Favorites.plist.
            
            let plistData = try Data(contentsOf: plistManager.documentsDirectoryFileURL()!)
            
            // Retrieves property list data and casts to dictionary with String and Any Key-Value pairs.
            
            if var favorites = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as? [String: Any] {
                
                savedFoodTextView.text = favorites["favFood"] as! String
                savedMovieTextView.text = favorites["favMovie"] as! String
                savedBookTextView.text = favorites["favBook"] as! String
            }
                
        } catch {
            
            print("Error retrieving Favorites.plist favorites array.")
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        readPropertyList()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
