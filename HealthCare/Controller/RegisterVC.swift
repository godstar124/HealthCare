//
//  RegisterVC.swift
//  HealthCare
//
//  Created by Mac on 4/7/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mPasswordField: UITextField!
    @IBOutlet weak var mEmailField: UITextField!
    @IBOutlet weak var mNameField: UITextField!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.mNameField.delegate = self
        self.mEmailField.delegate = self
        self.mPasswordField.delegate = self
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func nextView() {
        AppData.sharedInstance.setBLoggedIn(true)
        AppData.sharedInstance.setUserName(self.mNameField.text!)
        AppData.sharedInstance.setUserEmail(self.mEmailField.text!)
        AppData.sharedInstance.setUserPassword(self.mPasswordField.text!)
        
        let vcAddData = self.storyboard?.instantiateViewControllerWithIdentifier("AddDataVC") as? AddDataVC
        self.navigationController?.pushViewController(vcAddData!, animated: true)
    }
    
    @IBAction func onRegisterUser(sender: AnyObject) {
        
        if mNameField.text!.isEmpty || mEmailField.text!.isEmpty || mPasswordField.text!.isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Please type correctly!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        KCSUser.userWithUsername(self.mNameField.text,
                                password: self.mPasswordField.text,
                                fieldsAndValues: [
                                    KCSUserAttributeEmail: self.mEmailField.text!,
                                    KCSUserAttributeGivenname: self.mNameField.text!,
                                    KCSUserAttributeSurname: ""
                                ],
            withCompletionBlock: {(user: KCSUser!, errorOrNil:NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                // was successful!

                    let alert = UIAlertController(title: NSLocalizedString("Account Creation Successful", comment: "account success not title"),
                        message: NSLocalizedString("User created. Welcome!", comment: "account success message bogy"), preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: UIAlertActionStyle.Default) { (_) -> Void in
                            self.nextView()
                        }
                    )
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    // there was an error with the update save
                    let message = errorOrNil.localizedDescription
                    let alert = UIAlertController(title: NSLocalizedString("Create account failed", comment: "Create account failed"),
                        message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        })
        
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}