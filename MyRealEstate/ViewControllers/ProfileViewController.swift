//
//  ProfileViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UITextFieldDelegate {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let userId = ApiManager.sharedInstance.loadFromKeychain(ApiManager.USER_ID_KEY_NAME) {
            
            ApiManager.sharedInstance.loadUser(userId)
                .validate()
                .responseObject { (_, _, result: Result<User>) in
                    
                    switch(result) {
                    case .Success:
                        
                        if let user = result.value {
                            self.user = user
                            self.emailTextField.text = user.email
                            self.firstNameTextField.text = user.firstName
                            self.lastNameTextField.text = user.lastName
                            
                        }
                    case .Failure(_, let error):
                        print(error)
                        SCLAlertView().showError("Cannot load user", subTitle: "")
                    }
            }
        }

    }
    
    @IBAction func logoutClicked(sender: AnyObject) {
        
        // Clear the login token
        ApiManager.sharedInstance.clearFromKeychain(ApiManager.JWT_TOKEN_KEY_NAME)
        ApiManager.sharedInstance.clearFromKeychain(ApiManager.USER_ID_KEY_NAME)
        ApiManager.sharedInstance.clearFromKeychain(ApiManager.EMAIL_KEY_NAME)
        
        // Return to the login screen
        self.setRootViewController("LoginViewController")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Hide the keyboard when touching away from the textfield
        self.view.endEditing(true)
    }
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
}