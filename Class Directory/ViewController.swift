//
//  ViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableViewMain: UITableView!

    var peopleArray = [PersonOld]()
    var instructorArray = [PersonOld]()
    var plistpath : String?
    var instructorpath : String?
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    // #MARK: Lifecycle
                            
    override func viewDidLoad() {
                println("Lifecycle ViewDidLoad 01")
        super.viewDidLoad()
                println("Lifecycle ViewDidLoad 02")
        self.tableViewMain.dataSource = self
                println("Lifecycle ViewDidLoad 03")
        self.tableViewMain.delegate = self
                println("Lifecycle ViewDidLoad 04")
        self.createInstructorPlist()
                println("Lifecycle ViewDidLoad 05")
        self.createPeoplePlist()
                println("Lifecycle ViewDidLoad 06")
        
        fetchedResultController = getFetchedResultController()
                println("Lifecycle ViewDidLoad 07")
        fetchedResultController.delegate = self
                println("Lifecycle ViewDidLoad 08")
        fetchedResultController.performFetch(nil)
                println("Lifecycle ViewDidLoad 09")

        }


    override func didReceiveMemoryWarning() {
                    println("Lifecycle didReceiveMemoryWarning 01")
        super.didReceiveMemoryWarning()
                    println("Lifecycle didReceiveMemoryWarning 02")

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
                println("Lifecycle viewWillAppear 01")
        self.tableViewMain.reloadData()
                println("Lifecycle viewWillAppear 02")
        context?.save(nil)
                println("Lifecycle viewWillAppear 03")
//        println("Object Saved")
                println("Lifecycle viewWillAppear 04")
        
    }
    
//    #MARK: Serialization
    
    func createPeoplePlist() {
        
                println("Serialization createPeoplePlist 01")
        let fileManager = (NSFileManager.defaultManager())
                println("Serialization createPeoplePlist 02")
        let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
                println("Serialization createPeoplePlist 03")
        println("Value of directorys is \(directorys)")
        
        if directorys != nil {
                println("Serialization createPeoplePlist 04")
            let directories : [String] = directorys!
                println("Serialization createPeoplePlist 05")
            let pathToFile = directories[0]
                println("Serialization createPeoplePlist 06")
            let plistfile = "PeopleArray.plist"
                println("Serialization createPeoplePlist 07")

            plistpath = pathToFile.stringByAppendingPathComponent(plistfile);
                println("Serialization createPeoplePlist 08")

            if !fileManager.fileExistsAtPath(plistpath!){  //writing Plist file
                    println("Serialization createPeoplePlist 09")
                println("no Plist file found at \(plistpath)")
                    println("Serialization createPeoplePlist 10")
                self.createInitialPeople()
                    println("Serialization createPeoplePlist 11")
                println("Saving to Plist")
                
                [NSKeyedArchiver.archiveRootObject(peopleArray, toFile: plistpath!)]
                    println("Serialization createPeoplePlist 12")
                
                
            } else {            //Reading Plist file
                println("Serialization createPeoplePlist 13")
                println("\n\nPlist file found at \(plistpath)")
                
                }
            }
        }
    
    func createInstructorPlist() {
        
                println("Serialization createInstructorPlist 01")
        let fileManager = (NSFileManager.defaultManager())
                println("Serialization createInstructorPlist 02")
        let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
                println("Serialization createInstructorPlist 03")
        
        println("value of directorys is \(directorys)")
                println("Serialization createInstructorPlist 04")
        
        if (directorys != nil){
            
                println("Serialization createInstructorPlist 05")
            println("createInstructorPlist 1")
                println("Serialization createInstructorPlist 06")
            
            let directories:[String] = directorys!;
                println("Serialization createInstructorPlist 07")
            let pathToFile = directories[0]; //documents directory
                println("Serialization createInstructorPlist 08")
            
            let plistfile = "InstructorArray.plist"
                println("Serialization createInstructorPlist 09")
            instructorpath = pathToFile.stringByAppendingPathComponent(plistfile);
                println("Serialization createInstructorPlist 10")
           
            if !fileManager.fileExistsAtPath(instructorpath!){  //writing Plist file
                
                    println("Serialization createInstructorPlist 11")
                println("no Plist file found at \(instructorpath)")
                    println("Serialization createInstructorPlist 12")
                
                self.createInitialInstructors()
                    println("Serialization createInstructorPlist 13")
               
                println("Saving to Plist")

                    println("Serialization createInstructorPlist 14")
                [NSKeyedArchiver.archiveRootObject(instructorArray, toFile: instructorpath!)]
                
//                println("writing to path \(instructorpath)")
                
                
            } else {            //Reading Plist file
                
                println("\n\nPlist file found at \(instructorpath)")
                
//                instructorArray = NSKeyedUnarchiver.unarchiveObjectWithFile(instructorpath!) as [PersonOld]
                
                
            }
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: personFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        let fetchMe = fetchedResultController.description.debugDescription
        
        println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!result is \(fetchMe)")
        
        return fetchedResultController
    }
    
    func personFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "PeopleList")
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        println("sort descriptor is \(sortDescriptor)")
        
        return fetchRequest
    }

//    #MARK: Tableview

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
                println("D1")
                return 2
        
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        if (section == 0) {
                            println("Ea1")
            return "Instructors"
        } else {
                            println("Eb1")
            return "Students"
        }
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
                if (section == 0) {
                                    println("Fa1")
                    return self.instructorArray.count
                } else {
                    println("Fb1")
                    
                    return fetchedResultController.sections[section].numberOfObjects
//                return self.peopleArray.count
                }
        
        
//        let teacherCount = peopleArray.filter { (person : Person) -> Bool in
//            return person.isTeacher!
//            }.count
//                return teacherCount
        
        
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableViewMain.dequeueReusableCellWithIdentifier("CellMain", forIndexPath: indexPath) as UITableViewCell
        
        println("G1")
        
        if indexPath.section == 0 {
                                            println("Ga0")
            var personForRow = self.instructorArray[indexPath.row]
                    println("Ga1")
            cell.textLabel.text = personForRow.fullName()
                    println("Ga2")
            
        } else {
//            var personForRow = self.peopleArray[indexPath.row]
//            cell.textLabel.text = personForRow.fullName()
            
            println(indexPath)
                                            println("Gb0")
            println(indexPath)
            let personForRow = fetchedResultController.objectAtIndexPath(indexPath) as Person!
                                println("Gb1")
            
            cell.textLabel.text = personForRow.fullName()
                                            println("Gb2")
            
        }
        
        return cell
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "detailVCSegue" {
            if self.tableViewMain.indexPathForSelectedRow().section == 0 {
                
                var selectedPerson = self.instructorArray[self.tableViewMain.indexPathForSelectedRow().row]
                println("VC1")
                let vc = segue.destinationViewController as DetailViewController
                println("VC2")
                vc.selectedPerson = selectedPerson
                println("VC3 : value is \(selectedPerson.imageFor.imageAsset)")
                
            } else {
                
                var selectedPerson = self.peopleArray[self.tableViewMain.indexPathForSelectedRow().row]
                println("VC4")
                let vc = segue.destinationViewController as DetailViewController
                println("VC5")
                vc.selectedPerson = selectedPerson
                println("VC6 : value is \(selectedPerson.imageFor)")
            }
            
        } else {
            println("create")
        }
    }



//#MARK: Array initialization

    func createInitialPeople() {
        
        if peopleArray.isEmpty {
            
            let firstNamesLocal = ["Nate", "Matthew", "Jeff", "Christie", "David", "Adrian", "Jake", "Shams", "Cameron", "Kori", "Nathan", "Casey", "Brendan", "Brian", "Mark", "Rowan", "Kevin", "Will", "Heather", "Tuan", "Zack", "Sara", "Hongyao"]
            let lastNamesLocal = ["Birkholz", "Brightbill", "Chavez", "Ferderer", "Fry", "Gherle", "Hawken", "Kazi", "Klein", "Kolodziejczak", "Lewis", "Ma", "MacPhee", "McAleer", "Mendez", "Morris", "North", "Pham", "Richman", "Thueringer", "Vu", "Walkingstick", "Wong", "Zhang"]
            
            for i in 0..<firstNamesLocal.count {
                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
                managedPerson.firstName = firstNamesLocal[i]
                managedPerson.lastName = lastNamesLocal[i]
                managedPerson.isTeacher = false
                managedPerson.managedObjectContext.save(nil)
            }
            
            
            for Person in peopleArray {
                
                var newUser = NSEntityDescription.insertNewObjectForEntityForName("PeopleList", inManagedObjectContext: context) as NSManagedObject
                newUser.setValue(Person.firstName, forKey: "firstName")
                newUser.setValue(Person.lastName, forKey: "lastName")
                newUser.setPrimitiveValue(Person.isTeacher, forKey: "isTeacher")
                
                context!.save(nil)
                
//                println(newUser)
                print("Object Saved ")
                
            }
            
            println("newline")
            
        }
        
    }

    func createInitialInstructors() {
        
        if instructorArray.isEmpty {
            


            let firstNamesLocal = ["john", "brad"]
            let lastNamesLocal = ["clem", "johnson"]
            
            for i in 0..<firstNamesLocal.count {
                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
                managedPerson.firstName = firstNamesLocal[i]
                managedPerson.lastName = lastNamesLocal[i]
                managedPerson.isTeacher = true
                managedPerson.managedObjectContext.save(nil)
            }
            
            
            
            

            
            
            for Person in instructorArray {
                
                
                
//                var newUser = NSEntityDescription.insertNewObjectForEntityForName("PeopleList", inManagedObjectContext: context) as NSManagedObject
//                
//                newUser.setValue(Person.firstName, forKey: "firstName")
//                newUser.setValue(Person.lastName, forKey: "lastName")
//                newUser.setValue(Person.isTeacher.boolValue, forKey: "isTeacher")
                
                context!.save(nil)
                
//                println(newUser)
                println("Object Saved")
                
            }
            
        }
        
    }


    func dummyData() {
        
        let nateB = PersonOld(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
        self.peopleArray.append(nateB)

        let johnC = PersonOld(firstName: "John", lastName: "Clem", isTeacher: true)
        self.instructorArray.append(johnC)
        
    }
    
    
    //            var nateB = PersonOld(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
    //            var matthewB = PersonOld(firstName: "Matthew", lastName: "Brightbill", isTeacher: false)
    //            var jeffC = PersonOld(firstName: "Jeff", lastName: "Chavez", isTeacher: false)
    //            var christieF = PersonOld(firstName: "Christie", lastName: "Ferderer", isTeacher: false)
    //            var davidF = PersonOld(firstName: "David", lastName: "Fry", isTeacher: false)
    //            var adrianG = PersonOld(firstName: "Adrian", lastName: "Gherle", isTeacher: false)
    //            var jakeH = PersonOld(firstName: "Jake", lastName: "Hawken", isTeacher: false)
    //            var shamsK = PersonOld(firstName: "Shams", lastName: "Kazi", isTeacher: false)
    //            var cameronK = PersonOld(firstName: "Cameron", lastName: "Klein", isTeacher: false)
    //            var koriK = PersonOld(firstName: "Kori", lastName: "Kolodziejczak", isTeacher: false)
    //            var parkerL = PersonOld(firstName: "Parker", lastName: "Lewis", isTeacher: false)
    //            var nathanM = PersonOld(firstName: "Nathan", lastName: "Ma", isTeacher: false)
    //            var caseyM = PersonOld(firstName: "Casey", lastName: "MacPhee", isTeacher: false)
    //            var brendanM = PersonOld(firstName: "Brendan", lastName: "McAleer", isTeacher: false)
    //            var brianM = PersonOld(firstName: "Brian", lastName: "Mendez", isTeacher: false)
    //            var markM = PersonOld(firstName: "Mark", lastName: "Morris", isTeacher: false)
    //            var rowanN = PersonOld(firstName: "Rowan", lastName: "North", isTeacher: false)
    //            var kevinP = PersonOld(firstName: "Kevin", lastName: "Pham", isTeacher: false)
    //            var willR = PersonOld(firstName: "Will", lastName: "Richman", isTeacher: false)
    //            var heatherT = PersonOld(firstName: "Heather", lastName: "Thueringer", isTeacher: false)
    //            var tuanV = PersonOld(firstName: "Tuan", lastName: "Vu", isTeacher: false)
    //            var zackW = PersonOld(firstName: "Zack", lastName: "Walkingstick", isTeacher: false)
    //            var saraW = PersonOld(firstName: "Sara", lastName: "Wong", isTeacher: false)
    //            var hiongyaoZ = PersonOld(firstName: "Hongyao", lastName: "Zhang", isTeacher: false)
    
    //            (firstName: "John", lastName: "Clem", isTeacher: true)
    //            var bradJ = Person(firstName: "Brad", lastName: "Johnson", isTeacher: true)
    
    //            self.instructorArray.append(johnC)
    //            self.instructorArray.append(bradJ)
    

}
