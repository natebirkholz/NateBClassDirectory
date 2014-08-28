//
//  Person.swift
//  ClassDirectory
//
//  Created by Nathan Birkholz on 8/27/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Person)
class Person: NSManagedObject {

    @NSManaged var firstName: String
    @NSManaged var imageFor: UIImage
    @NSManaged var isTeacher: Bool
    @NSManaged var lastName: String
    
  
    
    func fullName() -> String {
        return firstName + " " + lastName
    }

}
