//
//  PersonClass.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import Foundation
import UIKit

class Person : NSObject {
    
    var firstName : String
    var lastName : String
    var imageFor : UIImage = UIImage(named: "stack21")
//    var isTeacher : Bool?
    
    init (firstName : String, lastName: String, imageFor: UIImage/*, isTeacher : Bool?*/) {
        self.firstName = firstName
        self.lastName = lastName
//        self.isTeacher = isTeacher
    }
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(firstName, forKey: "firstName")
        aCoder.encodeObject(lastName, forKey: "lastName")
        aCoder.encodeObject(imageFor, forKey: "imageFor")
//                aCoder.encodeObject(UIImagePNGRepresentation(self.imageFor), forKey: "imageFor")
//        aCoder.encodeObject(isTeacher!, forKey: "isTeacher")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.firstName = aDecoder.decodeObjectForKey("firstName") as String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as String
        self.imageFor = aDecoder.decodeObjectForKey("imageFor") as UIImage
//        self.isTeacher! = aDecoder.decodeObjectForKey("isTeacher") as Bool
    }
    
    
}