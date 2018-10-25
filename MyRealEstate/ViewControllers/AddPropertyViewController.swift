//
//  AddPropertyViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit

class AddPropertyViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add a button to save a new property
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "addPropertyDone:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addPropertyDone(sender: UIBarButtonItem) {
        if let userId = ApiManager.sharedInstance.loadFromKeychain(ApiManager.USER_ID_KEY_NAME) {
            let property = createPropertyFromUI()
            ApiManager.sharedInstance.addProperty(userId, property: property)
        }
    }
    
    func createPropertyFromUI() -> Property {
        let property: Property = Property()
        
        // TODO - Populate with info from UI
        
        return property
    }
}
