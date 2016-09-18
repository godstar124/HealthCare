//
//  AppData.swift
//  HealthCare
//
//  Created by Mac on 4/5/16.
//  Copyright © 2016 Green. All rights reserved.
//

import Foundation

class AppData: NSObject {

    class var sharedInstance: AppData {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AppData? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AppData()
        }
        return Static.instance!
    }
    
    func setBLoggedIn(bLoggedIn: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(bLoggedIn, forKey: Constants.kLoggedIn)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func bLoggedIn() -> Bool {
        if let bFlag = NSUserDefaults.standardUserDefaults().objectForKey(Constants.kLoggedIn) {
            return bFlag as! Bool
        }
        return false
    }
    
    func setUserName(userName: NSString) {
        NSUserDefaults.standardUserDefaults().setValue(userName, forKey: Constants.kUserName)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func userName() -> NSString {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.kUserName) as! NSString
    }
    
    func setUserEmail(userEmail: NSString) {
        NSUserDefaults.standardUserDefaults().setValue(userEmail, forKey: Constants.kUserEmail)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func userEmail() -> NSString {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.kUserEmail) as! NSString
    }
    
    func setUserPassword(userPassword: NSString) {
        NSUserDefaults.standardUserDefaults().setValue(userPassword, forKey: Constants.kUserPassword)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func userPassword() -> NSString {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.kUserPassword) as! NSString
    }

}