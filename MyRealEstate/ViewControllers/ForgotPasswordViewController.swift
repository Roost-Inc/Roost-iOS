//
//  ForgotPasswordViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStateForForgotPasswordButton(enabled: Bool) {
        self.resetPasswordButton.enabled = enabled
        self.resetPasswordButton.alpha = enabled ? 1.0 : 0.5
    }
    
    
    func checkValidInputFields() -> Bool {
        
        if(!validateEmail(emailTextField.text)) {
            SCLAlertView().showError("Error", subTitle: "Invalid email address")
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == emailTextField) {
            // "Go" button pressed on the password field
            // perform the password reset
            emailTextField.resignFirstResponder()
            resetPasswordClicked(self)
        }
        return true
    }
    
    @IBAction func resetPasswordClicked(sender: AnyObject) {
        
        setStateForForgotPasswordButton(false)
        
        if(!checkValidInputFields()) {
            setStateForForgotPasswordButton(true)
            return
        }
        
        self.view.endEditing(true)
        
        let alert = SCLAlertView().showSuccess("Password reset", subTitle: "An email to reset your password has been sent to \(emailTextField.text!)")
        alert.setDismissBlock({() -> Void in
            self.setStateForForgotPasswordButton(true)
            self.performSegueWithIdentifier("forgotPasswordDoneSegue", sender: self)
        })
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBOutlet var resetPasswordButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
}