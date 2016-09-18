//
//  UserData.swift
//  HealthCare
//
//  Created by Mac on 4/4/16.
//  Copyright © 2016 Green. All rights reserved.
//

import Foundation
import RealmSwift

class UserData: Object {
    
    dynamic var userName = ""
    dynamic var birth = ""
    dynamic var other = ""
}

class DataCollection: Object {
    
    dynamic var object_id = ""
}