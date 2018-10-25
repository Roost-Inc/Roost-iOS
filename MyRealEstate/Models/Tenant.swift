//
//  Tenant.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import Foundation

final class Tenant: ResponseObjectSerializable {
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let image: String
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.email = representation.valueForKeyPath("email") as! String
        self.phoneNumber = representation.valueForKeyPath("phoneNumber") as! String
        self.image = representation.valueForKeyPath("image") as! String
        self.firstName = representation.valueForKeyPath("firstName") as! String
        self.lastName = representation.valueForKeyPath("lastName") as! String
    }
    
    func toDictionary() -> NSDictionary {
        let dict : NSDictionary = NSDictionary()
        dict.setValue(email, forKey: "email")
        dict.setValue(phoneNumber, forKey: "phoneNumber")
        dict.setValue(image, forKey: "image")
        dict.setValue(firstName, forKey: "firstName")
        dict.setValue(lastName, forKey: "lastName")
        return dict
    }
}