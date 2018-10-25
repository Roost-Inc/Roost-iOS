//
//  SignupViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    let api = ApiManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func checkValidInputFields() -> Bool {
        
        if(!validateEmail(emailTextField.text)) {
            // Invalid email
            SCLAlertView().showError("Error", subTitle: "Invalid email address")
            return false
        }
        
        if(passwordTextField.text == nil || passwordTextField.text?.characters.count == 0) {
            // Password is required
            SCLAlertView().showError("Error", subTitle: "Password cannot be empty")
            return false
        }
        
        return true
    }
    
    func setStateForSignupButton(enabled: Bool) {
        self.signupButton.enabled = enabled
        self.signupButton.alpha = enabled ? 1.0 : 0.5
    }
    
    @IBAction func signupClicked(sender: AnyObject) {
        
        setStateForSignupButton(false)
        
        if(!checkValidInputFields()) {
            // Ensure the input is valid
            setStateForSignupButton(true)
            return
        }
        
        
        // Signup through the API manager
        // TODO
        api.register(emailTextField.text!, password: passwordTextField.text!)
        
        
        SCLAlertView().showInfo("Congratulations", subTitle: "You just created an account.")
        setStateForSignupButton(true)
        
        loginAfterRegister()
    }
    
    func loginAfterRegister() {
        
        // Login through the API manager
        // TODO
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch(textField) {
        case emailTextField:
            // Move from Email to Password text field
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
            
        case passwordTextField:
            // "Go" button pressed on the password field
            // perform the login
            passwordTextField.resignFirstResponder()
            signupClicked(self)
            break
            
        default:
            break
        }
        
        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Hide the keyboard when touching away from the textfield
        self.view.endEditing(true)
    }
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
}