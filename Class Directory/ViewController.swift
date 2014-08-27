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
        super.viewDidLoad()
        
        self.tableViewMain.dataSource = self
        self.tableViewMain.delegate = self
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
                
//                println("no Plist file found at \(plistpath)")
                
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
            let directories:[String] = directorys!;
            let pathToFile = directories[0]; //documents directory
            
            let plistfile = "InstructorArray.plist"
            instructorpath = pathToFile.stringByAppendingPathComponent(plistfile);
            
            if !fileManager.fileExistsAtPath(instructorpath!){  //writing Plist file
                
//                println("no Plist file found at \(instructorpath)")
                
                self.createInitialInstructors()
                
                println("Saving to Plist")
//
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
                return self.peopleArray.count
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
            
            
            var nateB = Person(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
            var matthewB = Person(firstName: "Matthew", lastName: "Brightbill", isTeacher: false)
            var jeffC = Person(firstName: "Jeff", lastName: "Chavez", isTeacher: false)
            var christieF = Person(firstName: "Christie", lastName: "Ferderer", isTeacher: false)
            var davidF = Person(firstName: "David", lastName: "Fry", isTeacher: false)
            var adrianG = Person(firstName: "Adrian", lastName: "Gherle", isTeacher: false)
            var jakeH = Person(firstName: "Jake", lastName: "Hawken", isTeacher: false)
            var shamsK = Person(firstName: "Shams", lastName: "Kazi", isTeacher: false)
            var cameronK = Person(firstName: "Cameron", lastName: "Klein", isTeacher: false)
            var koriK = Person(firstName: "Kori", lastName: "Kolodziejczak", isTeacher: false)
            var parkerL = Person(firstName: "Parker", lastName: "Lewis", isTeacher: false)
            var nathanM = Person(firstName: "Nathan", lastName: "Ma", isTeacher: false)
            var caseyM = Person(firstName: "Casey", lastName: "MacPhee", isTeacher: false)
            var brendanM = Person(firstName: "Brendan", lastName: "McAleer", isTeacher: false)
            var brianM = Person(firstName: "Brian", lastName: "Mendez", isTeacher: false)
            var markM = Person(firstName: "Mark", lastName: "Morris", isTeacher: false)
            var rowanN = Person(firstName: "Rowan", lastName: "North", isTeacher: false)
            var kevinP = Person(firstName: "Kevin", lastName: "Pham", isTeacher: false)
            var willR = Person(firstName: "Will", lastName: "Richman", isTeacher: false)
            var heatherT = Person(firstName: "Heather", lastName: "Thueringer", isTeacher: false)
            var tuanV = Person(firstName: "Tuan", lastName: "Vu", isTeacher: false)
            var zackW = Person(firstName: "Zack", lastName: "Walkingstick", isTeacher: false)
            var saraW = Person(firstName: "Sara", lastName: "Wong", isTeacher: false)
            var hiongyaoZ = Person(firstName: "Hongyao", lastName: "Zhang", isTeacher: false)
            
            self.peopleArray.append(nateB)
            self.peopleArray.append(matthewB)
            self.peopleArray.append(jeffC)
            self.peopleArray.append(christieF)
            self.peopleArray.append(davidF)
            self.peopleArray.append(adrianG)
            self.peopleArray.append(jakeH)
            self.peopleArray.append(shamsK)
            self.peopleArray.append(cameronK)
            self.peopleArray.append(koriK)
            self.peopleArray.append(parkerL)
            self.peopleArray.append(nathanM)
            self.peopleArray.append(caseyM)
            self.peopleArray.append(brendanM)
            self.peopleArray.append(brianM)
            self.peopleArray.append(markM)
            self.peopleArray.append(rowanN)
            self.peopleArray.append(kevinP)
            self.peopleArray.append(willR)
            self.peopleArray.append(heatherT)
            self.peopleArray.append(tuanV)
            self.peopleArray.append(zackW)
            self.peopleArray.append(saraW)
            self.peopleArray.append(hiongyaoZ)
            
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

            var johnC = Person(firstName: "John", lastName: "Clem", isTeacher: true)
            var bradJ = Person(firstName: "Brad", lastName: "Johnson", isTeacher: true)
            
            self.instructorArray.append(johnC)
            self.instructorArray.append(bradJ)
            
            
            for Person in instructorArray {
                
                
//                var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//                var context : NSManagedObjectContext = appDel.managedObjectContext!
                
                var newUser = NSEntityDescription.insertNewObjectForEntityForName("PeopleList", inManagedObjectContext: context) as NSManagedObject
                
                newUser.setValue(Person.firstName, forKey: "firstName")
                newUser.setValue(Person.lastName, forKey: "lastName")
                newUser.setValue(Person.isTeacher?.boolValue, forKey: "isTeacher")
                
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
