//
//  LoginViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load email from the keychain
        if let email = ApiManager.sharedInstance.loadFromKeychain(ApiManager.EMAIL_KEY_NAME) {
            emailTextField.text = email
        }
        // Set login button to enabled
        setStateForLoginButton(true)
    }
    
    @IBAction func loginClicked(sender: AnyObject) {

        // Disable the login button
        setStateForLoginButton(false)
        
        // Check for valid input
        if(!checkValidInputFields()) {
            setStateForLoginButton(true)
            return
        }
        
        // Login through the API manager
        ApiManager.sharedInstance.login(emailTextField.text!, password: passwordTextField.text!)
            .validate()
            .responseJSON { _, _, result in
                
                switch(result) {
                case .Success:
                    // Successful login
                    
                    // Save the JWT token to the keychain
                    let json = result.value as? NSDictionary // info will be nil if it's not an NSDictionary
                    let token = json?["token"] as? String
                    let userId = json?["id"] as? String
                    let email = json?["email"] as? String
                    
                    // Save token and user info to keychain
                    ApiManager.sharedInstance.saveToKeychain(ApiManager.JWT_TOKEN_KEY_NAME, value: token!)
                    ApiManager.sharedInstance.saveToKeychain(ApiManager.USER_ID_KEY_NAME, value: userId!)
                    ApiManager.sharedInstance.saveToKeychain(ApiManager.EMAIL_KEY_NAME, value: email!)
                    
                    // Clear the password text
                    self.passwordTextField.text = ""
                    
                    // Reenable the button
                    self.setStateForLoginButton(true)
                    
                    // Perform the segue to move to the main screen of the app
                    self.setRootViewController("MainTabBarController")
                    
                case .Failure(_, let error):
                    
                    print(error)
                    // Invalid email/password
                    SCLAlertView().showError("Error", subTitle: "Invalid email/password")
                    
                    // Reenable the button
                    self.setStateForLoginButton(true)
                }
        }

    }
    
    func setStateForLoginButton(enabled: Bool) {
        self.loginButton.enabled = enabled
        self.loginButton.alpha = enabled ? 1.0 : 0.5
    }
    
    func checkValidInputFields() -> Bool {
        
        
        if(!validateEmail(emailTextField.text)) {
            // Invalid email
            SCLAlertView().showError("Error", subTitle: "Invalid email address")
            return false
        }
        
        if(passwordTextField.text == nil || passwordTextField.text?.characters.count == 0) {
            // Password is required
            SCLAlertView().showError("Error", subTitle: "Password is required")
            return false
        }
        
        return true
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == emailTextField) {
            // Move from Email to Password text field
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if (textField == passwordTextField) {
            // "Go" button pressed on the password field
            // perform the login
            passwordTextField.resignFirstResponder()
            loginClicked(self)
        }
        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Hide the keyboard when touching away from the textfield
        self.view.endEditing(true)
    }
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
}