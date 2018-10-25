//
//  MainTabBarViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Verify token with server
        checkSavedLoginToken()
    }
    
    func checkSavedLoginToken() {
        ApiManager.sharedInstance.checkToken()
            .validate()
            .responseJSON { _, _, result in
                
                switch(result) {
                case .Success:
                    // Token is valid
                    break
                    
                case .Failure(_, let error):
                    
                    print(error)
                    
                    // Current token is invalid
                    ApiManager.sharedInstance.clearFromKeychain(ApiManager.JWT_TOKEN_KEY_NAME)
                    ApiManager.sharedInstance.clearFromKeychain(ApiManager.USER_ID_KEY_NAME)
                    ApiManager.sharedInstance.clearFromKeychain(ApiManager.EMAIL_KEY_NAME)
                    
                    // Return to the login screen
                    self.setRootViewController("LoginViewController")
                }
        }
    }
}

