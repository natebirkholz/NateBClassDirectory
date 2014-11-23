//
//  PersonClass.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

// http://www.flaticon.com

import Foundation
import UIKit
import CoreData

class PersonOld : NSObject {

  var firstName : String
  var lastName : String
  var imageFor : UIImage = UIImage()
  var isTeacher : Bool?

  let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

  init (firstName : String, lastName: String, isTeacher : Bool?) {
    self.firstName = firstName
    self.lastName = lastName
    self.isTeacher = isTeacher
  }

  func fullName() -> String {
    return firstName + " " + lastName
  }

  func encodeWithCoder(aCoder: NSCoder!) {
    aCoder.encodeObject(firstName, forKey: "firstName")
    aCoder.encodeObject(lastName, forKey: "lastName")
    aCoder.encodeObject(imageFor, forKey: "imageFor")
  }

  init (coder aDecoder: NSCoder!) {
    self.firstName = aDecoder.decodeObjectForKey("firstName") as String
    self.lastName = aDecoder.decodeObjectForKey("lastName") as String
    self.imageFor = aDecoder.decodeObjectForKey("imageFor") as UIImage
  }
  
} // End