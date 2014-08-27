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

class Person: NSManagedObject {

    @NSManaged var firstName: String
    var imageFor: UIImage = UIImage()
    var isTeacher: Bool?
    @NSManaged var lastName: String
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

    
    init (firstName : String, lastName: String, isTeacher : Bool?) {
        self.firstName = firstName
        self.lastName = lastName
        self.isTeacher = isTeacher
        
        let entityDescripition = NSEntityDescription.entityForName("PeopleList", inManagedObjectContext: context)
        
        super.init(entity: entityDescripition, insertIntoManagedObjectContext: context)
    }
    
    func fullName() -> String {
        return firstName + " " + lastName
    }

}
