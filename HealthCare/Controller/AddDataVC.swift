//
//  AddDataVC.swift
//  HealthCare
//
//  Created by Green on 04/04/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit
import RealmSwift

class AddDataVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mNameField: UITextField!
    @IBOutlet weak var mBirthField: UITextField!
    @IBOutlet weak var mOtherField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.hidden = true
        self.mNameField.delegate = self
        self.mBirthField.delegate = self
        self.mOtherField.delegate = self
        
        
        let store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "DataEntity",
            KCSStoreKeyCollectionTemplateClass : DataEntity.self
            ])
        
        let query = KCSQuery()
        let dataSort = KCSQuerySortModifier(field: KCSMetadataFieldLastModifiedTime, inDirection: KCSSortDirection.Descending)
        query.addSortModifier(dataSort)
        
        store.queryWithQuery(query,
            withCompletionBlock: {(objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if(errorOrNil == nil) {
                    NSLog("Successful reload: %@", objectsOrNil[0] as! NSObject)
                    let array = objectsOrNil as NSArray
                    let data = array[0] as! DataEntity
                    
                    self.mNameField.text = data.name
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-mm-dd"
                    self.mBirthField.text = formatter.stringFromDate(data.birth!)
                    self.mOtherField.text = data.other
                } else {
                    NSLog("error occurred: %@", errorOrNil)
                }

            }, withProgressBlock: nil
        )

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSaveBtn(sender: AnyObject) {
        let realm = try! Realm()
        let userData = UserData()
        userData.userName = self.mNameField.text!
        userData.birth = self.mBirthField.text!
        userData.other = self.mOtherField.text!
        
        try! realm.write() {
            realm.add(userData)
        }
    }
    
    @IBAction func onSendBtn(sender: AnyObject) {
        let realm = try! Realm()
        let userData = realm.objects(UserData).first
        let strData = NSString(format: "UserName: %@, Birth: %@, Other: %@", (userData?.userName)!, (userData?.birth)!, (userData?.other)!)
        
        // Send to Kinvey
        let store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "DataEntity",
            KCSStoreKeyCollectionTemplateClass : DataEntity.self
            ])
        
        let dataEntity = DataEntity()
        dataEntity.name = self.mNameField.text
        dataEntity.birth = NSDate(timeIntervalSince1970: 1352149171) //sample date
        dataEntity.other = self.mOtherField.text
        
        store.saveObject(
            dataEntity,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    NSLog("Save failed, with error: %@", errorOrNil.localizedFailureReason!)
                    
                    let alert = UIAlertController(title: "Alert",
                        message: String(format: "Save failed, with error: %@", errorOrNil.localizedFailureReason!), preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    //save was successful
                    NSLog("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                    let realm = try! Realm()
                    let collection = DataCollection()
                    collection.object_id = (objectsOrNil[0] as! NSObject).kinveyObjectId()
                    
                    try! realm.write() {
                        realm.add(collection)
                    }

                
                    let alert = UIAlertController(title: "Alert",
                        message: "Successfully Saved!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: UIAlertActionStyle.Default, handler: nil)                    )
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.mNameField.text = ""
                    self.mBirthField.text = ""
                    self.mOtherField.text = ""
                    
                }
            },
            withProgressBlock: nil
        )
        
        NSLog("%@", strData)
    }
}
