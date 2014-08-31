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
        context?.save(nil)
            println("Object Saved")
        fetchedResultController.performFetch(nil)

        self.tableViewMain.reloadData()
        
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
            
            let directories:[String] = directorys!;
            let pathToFile = directories[0]; //documents directory
            
            let plistfile = "InstructorArray.plist"
            instructorpath = pathToFile.stringByAppendingPathComponent(plistfile);
           
            if !fileManager.fileExistsAtPath(instructorpath!){  //writing Plist file
                
                println("no Plist file found at \(instructorpath)")
                
                self.createInitialInstructors()
               
                println("Saving to Plist")

                [NSKeyedArchiver.archiveRootObject(instructorArray, toFile: instructorpath!)]
                
                
            } else {            //Reading Plist file
                
                println("\n\nPlist file found at \(instructorpath)")
                
            }
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: personFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "isTeacher", cacheName: nil)
                
        return fetchedResultController
    }
    
    func personFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        let sortDescriptor1 = NSSortDescriptor(key: "isTeacher", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        println("sort descriptor is \(sortDescriptor1), \(sortDescriptor2)")
        
        return fetchRequest
    }

//    #MARK: Tableview

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
        return fetchedResultController.sections.count
        
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        if (section == 0) {
            return "Instructors"
        } else {
            return "Students"
            
        }
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections[section].numberOfObjects

        }

        
//        let teacherCount = peopleArray.filter { (person : Person) -> Bool in
//            return person.isTeacher!
//            }.count
//                return teacherCount
        
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableViewMain.dequeueReusableCellWithIdentifier("CellMain", forIndexPath: indexPath) as UITableViewCell
        
            let personForRow = fetchedResultController.objectAtIndexPath(indexPath) as Person
            cell.textLabel.text = personForRow.fullName()
            
            return cell
        
    }
    
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        println("section and row \(indexPath.section) \(indexPath.row) ")
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
        let personForRow : NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as Person
        context?.deleteObject(personForRow)
        context?.save(nil)
            tableViewMain.beginUpdates()
        tableViewMain!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableViewMain.endUpdates()
        }
        
//                if editingStyle == .Delete {
//                    // Delete the row from the data source
//                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        }
        //        } else if editingStyle == .Insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "detailVCSegue" {
            
                let cell = sender as UITableViewCell
                let indexPath = tableViewMain.indexPathForCell(cell)
                let vc = segue.destinationViewController as DetailViewController
                var selectedPerson: Person = fetchedResultController.objectAtIndexPath(indexPath) as Person
                vc.selectedPerson = selectedPerson

            
        } else {
            println("create")
        }
    }


//#MARK: Array initialization

    func createInitialPeople() {
            
            let firstNamesLocal = ["Nate", "Matthew", "Jeff", "Christie", "David", "Adrian", "Jake", "Shams", "Cameron", "Kori", "Nathan", "Casey", "Brendan", "Brian", "Mark", "Rowan", "Kevin", "Will", "Heather", "Tuan", "Zack", "Sara", "Hongyao"]
            let lastNamesLocal = ["Birkholz", "Brightbill", "Chavez", "Ferderer", "Fry", "Gherle", "Hawken", "Kazi", "Klein", "Kolodziejczak", "Lewis", "Ma", "MacPhee", "McAleer", "Mendez", "Morris", "North", "Pham", "Richman", "Thueringer", "Vu", "Walkingstick", "Wong", "Zhang"]
        
            for i in 0..<firstNamesLocal.count {
                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
                managedPerson.firstName = firstNamesLocal[i]
                managedPerson.lastName = lastNamesLocal[i]
                managedPerson.isTeacher = false
                managedPerson.managedObjectContext.save(nil)
                
            }
        self.dummyPeople()

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
        
            let firstNamesLocal = ["John", "Brad"]
            let lastNamesLocal = ["Clem", "Johnson"]
        
            for i in 0..<firstNamesLocal.count {
                let managedPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
                managedPerson.firstName = firstNamesLocal[i]
                managedPerson.lastName = lastNamesLocal[i]
                managedPerson.isTeacher = true
                managedPerson.managedObjectContext.save(nil)

        }
        self.dummyInstructors()

    }


    func dummyInstructors() {

        let johnC = PersonOld(firstName: "John", lastName: "Clem", isTeacher: true)
        self.instructorArray.append(johnC)
        
    }
    
    func dummyPeople() {
        
        let nateB = PersonOld(firstName: "Nate", lastName: "Birkholz", isTeacher: false)
        self.peopleArray.append(nateB)
        
    }
    

    

}
