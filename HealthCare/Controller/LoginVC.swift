//
//  LoginVC.swift
//  HealthCare
//
//  Created by Green on 04/04/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var mPasswordTextField: UITextField!
    
    @IBOutlet weak var mUserNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mUserNameTextField.delegate = self
        self.mPasswordTextField.delegate = self
        
        if AppData.sharedInstance.bLoggedIn() {
            self.nextViewController()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func nextViewController() {
        
        let vcAddData = self.storyboard?.instantiateViewControllerWithIdentifier("AddDataVC") as? AddDataVC
        self.navigationController?.pushViewController(vcAddData!, animated: true)
    }
    
    @IBAction func onLoginBtn(sender: AnyObject) {
        
        if mUserNameTextField.text!.isEmpty || mPasswordTextField.text!.isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Please type correctly!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        KCSUser.loginWithUsername(self.mUserNameTextField.text!,
            password: self.mPasswordTextField.text!,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    // login success
                    
                    AppData.sharedInstance.setBLoggedIn(true)
                    AppData.sharedInstance.setUserName(self.mUserNameTextField.text!)
                    AppData.sharedInstance.setUserPassword(self.mPasswordTextField.text!)
                    
                    self.nextViewController()
                } else {
                    let message = errorOrNil.localizedDescription
                    let alert = UIAlertController(title: NSLocalizedString("Create account failed", comment: "Sign account failed"),
                        message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        })
    }
    
    @IBAction func onRegisterBtn(sender: AnyObject) {
        
        
        let vcRegister = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterVC") as? RegisterVC
        self.navigationController?.pushViewController(vcRegister!, animated: true)
        
    }
}
