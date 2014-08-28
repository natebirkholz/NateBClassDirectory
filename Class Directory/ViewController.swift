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

    var peopleArray = [Person]()
    var instructorArray = [Person]()
    var plistpath : String?
    var instructorpath : String?
    

    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    // #MARK: Lifecycle
                            
    override func viewDidLoad() {
            println("1111")
        super.viewDidLoad()
            println("2222")
        self.tableViewMain.dataSource = self
            println("3333")
        self.tableViewMain.delegate = self
            println("4444")
        self.createInstructorPlist()
        println("A1")
        self.createPeoplePlist()
        println("A2")

        
        fetchedResultController = getFetchedResultController()
        
        println("A3")

        
        fetchedResultController.delegate = self
        
        println("A4")

        
        fetchedResultController.performFetch(nil)
        
        println("A5")


        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        println("B1")


    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("C1")

        
        self.tableViewMain.reloadData()
        
                println("C2")
        
//        [NSKeyedArchiver.archiveRootObject(instructorArray, toFile: instructorpath!)]
//        [NSKeyedArchiver.archiveRootObject(peopleArray, toFile: plistpath!)]
        
//        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        context?.save(nil)
        
                println("C3")

        println("Object Saved")
        
                println("C4")
        
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
                
//                println("writing to path \(plistpath)")
                
                
            } else {            //Reading Plist file
                
                println("\n\nPlist file found at \(plistpath)")
                
//                peopleArray = NSKeyedUnarchiver.unarchiveObjectWithFile(plistpath!) as [Person]
                
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
            println("createInstructorPlist 2")
            let pathToFile = directories[0]; //documents directory
            
            let plistfile = "InstructorArray.plist"
            instructorpath = pathToFile.stringByAppendingPathComponent(plistfile);
            
            if !fileManager.fileExistsAtPath(instructorpath!){  //writing Plist file
                
                println("no Plist file found at \(instructorpath)")
                
                self.createInitialInstructors()
                
                println("Saving to Plist")

                [NSKeyedArchiver.archiveRootObject(instructorArray, toFile: instructorpath!)]
                
//                println("writing to path \(instructorpath)")
                
                
            } else {            //Reading Plist file
                
                println("\n\nPlist file found at \(instructorpath)")
                
                instructorArray = NSKeyedUnarchiver.unarchiveObjectWithFile(instructorpath!) as [Person]
                
                
            }
        }
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
            
            
//            var nateB = PersonOld(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
//            var matthewB = PersonOld(firstName: "Matthew", lastName: "Brightbill", isTeacher: false)
            
            var nateB = Person()
            nateB.firstName = "Nate"
            nateB.lastName = "Birkholz"
            nateB.isTeacher = false
            
            var matthewB = Person()
            matthewB.firstName = "Nate"
            matthewB.lastName = "Birkholz"
            matthewB.isTeacher = false
            
            
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
            
            self.peopleArray.append(nateB)
            self.peopleArray.append(matthewB)
//            self.peopleArray.append(jeffC)
//            self.peopleArray.append(christieF)
//            self.peopleArray.append(davidF)
//            self.peopleArray.append(adrianG)
//            self.peopleArray.append(jakeH)
//            self.peopleArray.append(shamsK)
//            self.peopleArray.append(cameronK)
//            self.peopleArray.append(koriK)
//            self.peopleArray.append(parkerL)
//            self.peopleArray.append(nathanM)
//            self.peopleArray.append(caseyM)
//            self.peopleArray.append(brendanM)
//            self.peopleArray.append(brianM)
//            self.peopleArray.append(markM)
//            self.peopleArray.append(rowanN)
//            self.peopleArray.append(kevinP)
//            self.peopleArray.append(willR)
//            self.peopleArray.append(heatherT)
//            self.peopleArray.append(tuanV)
//            self.peopleArray.append(zackW)
//            self.peopleArray.append(saraW)
//            self.peopleArray.append(hiongyaoZ)
            
            for Person in peopleArray {
                
//                var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//                var context : NSManagedObjectContext = appDel.managedObjectContext!
                
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
            
            let johnC = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
            johnC.firstName = "John"
            johnC.lastName = "Clem"
            johnC.isTeacher = true
            johnC.managedObjectContext.save(nil)

            let bradJ = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
            bradJ.firstName = "John"
            bradJ.lastName = "Clem"
            bradJ.isTeacher = true
            bradJ.managedObjectContext.save(nil)

//            let firstNames = ["john", "brad"]
//            let lastNames = ["clem", "johnson"]
//            
//            for i in 0..<firstNames.count {
//                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
//                managedPerson.firstName = firstNames[i]
//                managedPerson.lastName = lastNames[i]
//                managedPerson.isTeacher = true
//                managedPerson.managedObjectContext.save(nil)
//            }
            
            
            
            
//            (firstName: "John", lastName: "Clem", isTeacher: true)
//            var bradJ = Person(firstName: "Brad", lastName: "Johnson", isTeacher: true)
            
            self.instructorArray.append(johnC)
            self.instructorArray.append(bradJ)
            
            
            for Person in instructorArray {
                
                
//                var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//                var context : NSManagedObjectContext = appDel.managedObjectContext!
                
                var newUser = NSEntityDescription.insertNewObjectForEntityForName("PeopleList", inManagedObjectContext: context) as NSManagedObject
                
                newUser.setValue(Person.firstName, forKey: "firstName")
                newUser.setValue(Person.lastName, forKey: "lastName")
                newUser.setValue(Person.isTeacher.boolValue, forKey: "isTeacher")
                
                context!.save(nil)
                
//                println(newUser)
                println("Object Saved")
                
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


}
