//
//  ViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewMain: UITableView!

    var peopleArray = [Person]()
    var instructorArray = [Person]()
    var plistpath : String?
    var instructorpath : String?
//    var masterArray = [[Person](), [Person]()] as Array
    
    // #MARK: Lifecycle
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewMain.dataSource = self
        self.tableViewMain.delegate = self
        self.createInstructorPlist()
        self.createPeoplePlist()

        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableViewMain.reloadData()
        
        [NSKeyedArchiver.archiveRootObject(instructorArray, toFile: instructorpath!)]
        [NSKeyedArchiver.archiveRootObject(peopleArray, toFile: plistpath!)]
        
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
                
                self.createInitialPeople()
                
                println("Saving to Plist")
                
                [NSKeyedArchiver.archiveRootObject(peopleArray, toFile: plistpath!)]
                
//                println("writing to path \(plistpath)")
                
                
            } else {            //Reading Plist file
                println("\n\nPlist file found at \(plistpath)")
                
                peopleArray = NSKeyedUnarchiver.unarchiveObjectWithFile(plistpath!) as [Person]
                
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
                return 2
        
        
//        println("Number of sections is \(self.masterArray.count)")
//        return self.masterArray.count
        
        
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        if (section == 0) {
            return "Instructors"
        } else {
            return "Students"
        }
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
                if (section == 0) {
                    return self.instructorArray.count
                } else {
                return self.peopleArray.count
                }
        
//        return self.masterArray[section].count
        
//        let teacherCount = peopleArray.filter { (person : Person) -> Bool in
//            return person.isTeacher!
//            }.count
//                return teacherCount
        
        
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell = tableViewMain.dequeueReusableCellWithIdentifier("CellMain", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.section == 0 {
            var personForRow = self.instructorArray[indexPath.row]
            cell.textLabel.text = personForRow.fullName()
        } else {
            
            var personForRow = self.peopleArray[indexPath.row]
            cell.textLabel.text = personForRow.fullName()
        }
        
//        println("cell is \(cell), indexpath is \(indexPath)")
        
        return cell
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "detailVCSegue" {
            if self.tableViewMain.indexPathForSelectedRow().section == 0 {
                
//                var selectedArray = self.masterArray[self.tableViewMain.indexPathForSelectedRow().section]
//                var selectedPerson = selectedArray[self.tableViewMain.indexPathForSelectedRow().row]
                
                var selectedPerson = self.instructorArray[self.tableViewMain.indexPathForSelectedRow().row]
                println("VC1")
                let vc = segue.destinationViewController as DetailViewController
                println("VC2")
                vc.selectedPerson = selectedPerson
                println("VC3")
                
            } else {
                
                var selectedPerson = self.peopleArray[self.tableViewMain.indexPathForSelectedRow().row]
                println("VC4")
                let vc = segue.destinationViewController as DetailViewController
                println("VC5")
                vc.selectedPerson = selectedPerson
                println("VC6")
            }
            
        }
    }



//#MARK: Array initialization

    func createInitialPeople() {
        
        if peopleArray.isEmpty {
            
            var nateB = Person(firstName: "Nate", lastName: "Birkholz", imageFor: UIImage(named: "stack21"))
            var matthewB = Person(firstName: "Matthew", lastName: "Brightbill", imageFor: UIImage(named: "stack21"))
            var jeffC = Person(firstName: "Jeff", lastName: "Chavez", imageFor: UIImage(named: "stack21"))
            var christieF = Person(firstName: "Christie", lastName: "Ferderer", imageFor: UIImage(named: "stack21"))
            var davidF = Person(firstName: "David", lastName: "Fry", imageFor: UIImage(named: "stack21"))
            var adrianG = Person(firstName: "Adrian", lastName: "Gherle", imageFor: UIImage(named: "stack21"))
            var jakeH = Person(firstName: "Jake", lastName: "Hawken", imageFor: UIImage(named: "stack21"))
            var shamsK = Person(firstName: "Shams", lastName: "Kazi", imageFor: UIImage(named: "stack21"))
            var cameronK = Person(firstName: "Cameron", lastName: "Klein", imageFor: UIImage(named: "stack21"))
            var koriK = Person(firstName: "Kori", lastName: "Kolodziejczak", imageFor: UIImage(named: "stack21"))
            var parkerL = Person(firstName: "Parker", lastName: "Lewis", imageFor: UIImage(named: "stack21"))
            var nathanM = Person(firstName: "Nathan", lastName: "Ma", imageFor: UIImage(named: "stack21"))
            var caseyM = Person(firstName: "Casey", lastName: "MacPhee", imageFor: UIImage(named: "stack21"))
            var brendanM = Person(firstName: "Brendan", lastName: "McAleer", imageFor: UIImage(named: "stack21"))
            var brianM = Person(firstName: "Brian", lastName: "Mendez", imageFor: UIImage(named: "stack21"))
            var markM = Person(firstName: "Mark", lastName: "Morris", imageFor: UIImage(named: "stack21"))
            var rowanN = Person(firstName: "Rowan", lastName: "North", imageFor: UIImage(named: "stack21"))
            var kevinP = Person(firstName: "Kevin", lastName: "Pham", imageFor: UIImage(named: "stack21"))
            var willR = Person(firstName: "Will", lastName: "Richman", imageFor: UIImage(named: "stack21"))
            var heatherT = Person(firstName: "Heather", lastName: "Thueringer", imageFor: UIImage(named: "stack21"))
            var tuanV = Person(firstName: "Tuan", lastName: "Vu", imageFor: UIImage(named: "stack21"))
            var zackW = Person(firstName: "Zack", lastName: "Walkingstick", imageFor: UIImage(named: "stack21"))
            var saraW = Person(firstName: "Sara", lastName: "Wong", imageFor: UIImage(named: "stack21"))
            var hiongyaoZ = Person(firstName: "Hongyao", lastName: "Zhang", imageFor: UIImage(named: "stack21"))
            
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
            
//            self.masterArray[1].append(nateB)
//            self.masterArray[1].append(matthewB)
//            self.masterArray[1].append(jeffC)
//            self.masterArray[1].append(christieF)
//            self.masterArray[1].append(davidF)
//            self.masterArray[1].append(adrianG)
//            self.masterArray[1].append(jakeH)
//            self.masterArray[1].append(shamsK)
//            self.masterArray[1].append(cameronK)
//            self.masterArray[1].append(koriK)
//            self.masterArray[1].append(parkerL)
//            self.masterArray[1].append(nathanM)
//            self.masterArray[1].append(caseyM)
//            self.masterArray[1].append(brendanM)
//            self.masterArray[1].append(brianM)
//            self.masterArray[1].append(markM)
//            self.masterArray[1].append(rowanN)
//            self.masterArray[1].append(kevinP)
//            self.masterArray[1].append(willR)
//            self.masterArray[1].append(heatherT)
//            self.masterArray[1].append(tuanV)
//            self.masterArray[1].append(zackW)
//            self.masterArray[1].append(saraW)
//            self.masterArray[1].append(hiongyaoZ)
            
            
        }
    }

    func createInitialInstructors() {
        
        if instructorArray.isEmpty {
            
            var johnC = Person(firstName: "John", lastName: "Clem", imageFor: UIImage(named: "stack21"))
            var bradJ = Person(firstName: "Brad", lastName: "Johnson", imageFor: UIImage(named: "stack21"))
            
            self.instructorArray.append(johnC)
            self.instructorArray.append(bradJ)
            
//            self.masterArray[0].append(johnC)
//            self.masterArray[0].append(bradJ)
            
            
        }
        
    }


}
