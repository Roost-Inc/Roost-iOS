//
//  User.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import Foundation

final class User: ResponseObjectSerializable {
    let email: String
    let firstName: String
    let lastName: String
    let id: String
    var properties: [Property]
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.email = representation.valueForKeyPath("email") as! String
        self.id = representation.valueForKeyPath("_id") as! String
        self.firstName = representation.valueForKeyPath("firstName") as! String
        self.lastName = representation.valueForKeyPath("lastName") as! String
        
        let propertyData = representation.valueForKeyPath("properties") as! NSArray
        self.properties = Property.collection(response: response, representation: propertyData)
    }
    
    func toDictionary() -> NSDictionary {
        let dict : NSDictionary = NSDictionary()
        
        let propertiesJsonArray = NSMutableArray()
        
        for item in properties {
            propertiesJsonArray.addObject(item.toDictionary())
        }
        
        dict.setValue(email, forKey: "email")
        dict.setValue(id, forKey: "id")
        dict.setValue(propertiesJsonArray, forKey: "properties")
        dict.setValue(firstName, forKey: "firstName")
        dict.setValue(lastName, forKey: "lastName")
        return dict
    }
}