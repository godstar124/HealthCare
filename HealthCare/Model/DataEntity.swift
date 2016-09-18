//
//  DataEntity.swift
//  HealthCare
//
//  Created by Mac on 4/7/16.
//  Copyright © 2016 Green. All rights reserved.
//

import Foundation

class DataEntity : NSObject {    //all NSObjects in Kinvey implicitly implement KCSPersistable
    var entityId: String? //Kinvey entity _id
    var name: String?
    var birth: NSDate?
    var other: String?
    var metadata: KCSMetadata? //Kinvey metadata, optional
    
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "name" : "name",
            "birth" : "bith",
            "other" : "other",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
}

