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
        super.viewDidLoad()
        self.tableViewMain.dataSource = self
        self.tableViewMain.delegate = self
        self.createInstructorPlist()
        self.createPeoplePlist()
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)

        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableViewMain.reloadData()
        context?.save(nil)
//        println("Object Saved")
        
    }
    
//    #MARK: Serialization
    
    
    func createPeoplePlist() {
        
        let fileManager = (NSFileManager.defaultManager())
        let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        println("Value of directorys is \(directorys)")
        
        if directorys != nil {
            let directories : [String] = directorys!
            let pathToFile = directories[0]
            let plistfile = "PeopleArray.plist"

            plistpath = pathToFile.stringByAppendingPathComponent(plistfile);

            if !fileManager.fileExistsAtPath(plistpath!){  //writing Plist file
                println("no Plist file found at \(plistpath)")
                self.createInitialPeople()
                println("Saving to Plist")
                
                [NSKeyedArchiver.archiveRootObject(peopleArray, toFile: plistpath!)]
                
                
            } else {            //Reading Plist file
                println("\n\nPlist file found at \(plistpath)")
                
                }
            }
        }
    
    func createInstructorPlist() {
        
        let fileManager = (NSFileManager.defaultManager())
        let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        println("value of directorys is \(directorys)")
        
        if (directorys != nil){
            
            println("createInstructorPlist 1")
            
            let directories:[String] = directorys!;
            let pathToFile = directories[0]; //documents directory
            
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
                    println("Serialization createInstructorPlist 15")
                
                
            } else {            //Reading Plist file
                
                    println("Serialization createInstructorPlist 16")
                println("\n\nPlist file found at \(instructorpath)")
                    println("Serialization createInstructorPlist 17")
                
            }
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        
                println("Serialization getFetchedResultController 01")
        fetchedResultController = NSFetchedResultsController(fetchRequest: personFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "isTeacher", cacheName: nil)
        
                println("Serialization getFetchedResultController 02")
        let fetchMe = fetchedResultController.description.debugDescription
                println("Serialization getFetchedResultController 03")
        
        println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!result is \(fetchMe)")
        
        return fetchedResultController
    }
    
    func personFetchRequest() -> NSFetchRequest {
                println("Serialization personFetchRequest 01")
        let fetchRequest = NSFetchRequest(entityName: "Person")
                println("Serialization personFetchRequest 02")
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
                println("Serialization personFetchRequest 03")
        fetchRequest.sortDescriptors = [sortDescriptor]
                println("Serialization personFetchRequest 04")
        
        println("sort descriptor is \(sortDescriptor)")
                println("Serialization personFetchRequest 05")
        
        return fetchRequest
    }

//    #MARK: Tableview

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
                println("Tableview numberOfSectionsInTableView 01")
        
        return fetchedResultController.sections.count
        
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
                println("Tableview titleForHeaderInSection 01")
        if (section == 0) {
                println("Tableview titleForHeaderInSection 02")
            return "Students"
        } else {
                println("Tableview titleForHeaderInSection 03")
            return "Instructors"
        }
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
                println("Tableview heightForHeaderInSection 01")
        return 70.0
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
                println("Tableview numberOfRowsInSection 01")
        return fetchedResultController.sections[section].numberOfObjects

        }

        
//        let teacherCount = peopleArray.filter { (person : Person) -> Bool in
//            return person.isTeacher!
//            }.count
//                return teacherCount
        
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
                println("Tableview cellForRowAtIndexPath 01")
        let cell = tableViewMain.dequeueReusableCellWithIdentifier("CellMain", forIndexPath: indexPath) as UITableViewCell
                println("Tableview cellForRowAtIndexPath 02")
        
        if indexPath.section == 0 {
                    println("Tableview cellForRowAtIndexPath 03")
            let personForRow = fetchedResultController.objectAtIndexPath(indexPath) as Person
                    println("Tableview cellForRowAtIndexPath 04")
            
            cell.textLabel.text = personForRow.fullName()
                println("Tableview cellForRowAtIndexPath 05")
            
            return cell
            
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
                println("Tableview prepareForSegue 01")
        if segue.identifier == "detailVCSegue" {
                println("Tableview prepareForSegue 02")
           if self.tableViewMain.indexPathForSelectedRow().section == 0 {
                
                    println("Tableview prepareForSegue 03")
                let cell = sender as UITableViewCell
                    println("Tableview prepareForSegue 04")
                let indexPath = tableViewMain.indexPathForCell(cell)
                    println("Tableview prepareForSegue 05")
                let vc = segue.destinationViewController as DetailViewController
                    println("Tableview prepareForSegue 06")
                var selectedPerson: Person = fetchedResultController.objectAtIndexPath(indexPath) as Person
                    println("Tableview prepareForSegue 07")
                vc.selectedPerson = selectedPerson
                    println("Tableview prepareForSegue 08")

            
            } else {
                
//                var selectedPerson = self.peopleArray[self.tableViewMain.indexPathForSelectedRow().row]
//                println("VC4")
//                let vc = segue.destinationViewController as DetailViewController
//                println("VC5")
//                vc.selectedPerson = selectedPerson
//                println("VC6 : value is \(selectedPerson.imageFor)")
            }
            
        } else {
            println("create")
        }
    }


//#MARK: Array initialization

    func createInitialPeople() {
            
                println("Array initialization createInitialPeople 01")
            let firstNamesLocal = ["Nate", "Matthew", "Jeff", "Christie", "David", "Adrian", "Jake", "Shams", "Cameron", "Kori", "Nathan", "Casey", "Brendan", "Brian", "Mark", "Rowan", "Kevin", "Will", "Heather", "Tuan", "Zack", "Sara", "Hongyao"]
                println("Array initialization createInitialPeople 02")
            let lastNamesLocal = ["Birkholz", "Brightbill", "Chavez", "Ferderer", "Fry", "Gherle", "Hawken", "Kazi", "Klein", "Kolodziejczak", "Lewis", "Ma", "MacPhee", "McAleer", "Mendez", "Morris", "North", "Pham", "Richman", "Thueringer", "Vu", "Walkingstick", "Wong", "Zhang"]
                println("Array initialization createInitialPeople 01")
        
            for i in 0..<firstNamesLocal.count {
                    println("Array initialization createInitialPeople 01")
                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
                    println("Array initialization createInitialPeople 02")
                managedPerson.firstName = firstNamesLocal[i]
                    println("Array initialization createInitialPeople 03")
                managedPerson.lastName = lastNamesLocal[i]
                    println("Array initialization createInitialPeople 04")
                managedPerson.isTeacher = false
                    println("Array initialization createInitialPeople 05")
                managedPerson.managedObjectContext.save(nil)
                    println("Array initialization createInitialPeople 06")
                
            }
            println("Array initialization createInitialPeople 07")
        self.dummyPeople()
            println("Array initialization createInitialPeople 08")

    }
    
//            for Person in peopleArray {
//                
//                var newUser = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
//                newUser.setValue(Person.firstName, forKey: "firstName")
//                newUser.setValue(Person.lastName, forKey: "lastName")
//                newUser.setPrimitiveValue(Person.isTeacher, forKey: "isTeacher")
//                
//                context!.save(nil)
//                
////                println(newUser)
//                print("Object Saved ")
//                
//            }
//            
//            println("newline")
//            
//        }
//        
//    }

    func createInitialInstructors() {
        
                    println("Array initialization createInitialInstructors 01")
            let firstNamesLocal = ["john", "brad"]
                    println("Array initialization createInitialInstructors 02")
            let lastNamesLocal = ["clem", "johnson"]
                    println("Array initialization createInitialInstructors 03")
        
            for i in 0..<firstNamesLocal.count {
                    println("Array initialization createInitialInstructors 04")
                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
                    println("Array initialization createInitialInstructors 05")
                managedPerson.firstName = firstNamesLocal[i]
                    println("Array initialization createInitialInstructors 06")
                managedPerson.lastName = lastNamesLocal[i]
                    println("Array initialization createInitialInstructors 07")
                managedPerson.isTeacher = true
                    println("Array initialization createInitialInstructors 08")
                managedPerson.managedObjectContext.save(nil)
                    println("Array initialization createInitialInstructors 09")
//                context!.save(nil)
        }
        self.dummyInstructors()
            println("Array initialization createInitialInstructors 10")
    }


    func dummyInstructors() {

            println("Array initialization dummyInstructors 01")
        let johnC = PersonOld(firstName: "John", lastName: "Clem", isTeacher: true)
            println("Array initialization dummyInstructors 02")
        self.instructorArray.append(johnC)
            println("Array initialization dummyInstructors 03")
        
    }
    
    func dummyPeople() {
        
            println("Array initialization dummyPeople 01")
        let nateB = PersonOld(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
            println("Array initialization dummyPeople 02")
        self.peopleArray.append(nateB)
            println("Array initialization dummyPeople 03")
        
    }
    
    
    //  var nateB = PersonOld(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
    //  var matthewB = PersonOld(firstName: "Matthew", lastName: "Brightbill", isTeacher: false)
    //  var jeffC = PersonOld(firstName: "Jeff", lastName: "Chavez", isTeacher: false)
    //  var christieF = PersonOld(firstName: "Christie", lastName: "Ferderer", isTeacher: false)
    //  var davidF = PersonOld(firstName: "David", lastName: "Fry", isTeacher: false)
    //  var adrianG = PersonOld(firstName: "Adrian", lastName: "Gherle", isTeacher: false)
    //  var jakeH = PersonOld(firstName: "Jake", lastName: "Hawken", isTeacher: false)
    //  var shamsK = PersonOld(firstName: "Shams", lastName: "Kazi", isTeacher: false)
    //  var cameronK = PersonOld(firstName: "Cameron", lastName: "Klein", isTeacher: false)
    //  var koriK = PersonOld(firstName: "Kori", lastName: "Kolodziejczak", isTeacher: false)
    //  var parkerL = PersonOld(firstName: "Parker", lastName: "Lewis", isTeacher: false)
    //  var nathanM = PersonOld(firstName: "Nathan", lastName: "Ma", isTeacher: false)
    //  var caseyM = PersonOld(firstName: "Casey", lastName: "MacPhee", isTeacher: false)
    //  var brendanM = PersonOld(firstName: "Brendan", lastName: "McAleer", isTeacher: false)
    //  var brianM = PersonOld(firstName: "Brian", lastName: "Mendez", isTeacher: false)
    //  var markM = PersonOld(firstName: "Mark", lastName: "Morris", isTeacher: false)
    //  var rowanN = PersonOld(firstName: "Rowan", lastName: "North", isTeacher: false)
    //  var kevinP = PersonOld(firstName: "Kevin", lastName: "Pham", isTeacher: false)
    //  var willR = PersonOld(firstName: "Will", lastName: "Richman", isTeacher: false)
    //  var heatherT = PersonOld(firstName: "Heather", lastName: "Thueringer", isTeacher: false)
    //  var tuanV = PersonOld(firstName: "Tuan", lastName: "Vu", isTeacher: false)
    //  var zackW = PersonOld(firstName: "Zack", lastName: "Walkingstick", isTeacher: false)
    //  var saraW = PersonOld(firstName: "Sara", lastName: "Wong", isTeacher: false)
    //  var hiongyaoZ = PersonOld(firstName: "Hongyao", lastName: "Zhang", isTeacher: false)
    
    //  var johnC = Person(firstName: "John", lastName: "Clem", isTeacher: true)
    //  var bradJ = Person(firstName: "Brad", lastName: "Johnson", isTeacher: true)
    
    //  self.instructorArray.append(johnC)
    //  self.instructorArray.append(bradJ)
    

}
