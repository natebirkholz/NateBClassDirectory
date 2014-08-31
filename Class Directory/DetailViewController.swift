//
//  DetailViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedPerson : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var instructorSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    
//  #MARK: Lifecycle
    
    override func viewDidLoad() {
    
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        if selectedPerson? == nil{
            println("NIL PERSON YO")
        }
        


            println("DVC Lifecycle viewDidLoad 01")
        super.viewDidLoad()
        
//        self.navigationItem.backBarButtonItem.title = "Previous"
            println("DVC Lifecycle viewDidLoad 02")
        self.firstNameField.text = self.selectedPerson?.firstName
            println("DVC Lifecycle viewDidLoad 03")
        self.lastNameField.text = self.selectedPerson?.lastName
            println("DVC Lifecycle viewDidLoad 04")
        self.imageView.layer.masksToBounds = true
            println("DVC Lifecycle viewDidLoad 05")
        self.imageView.layer.cornerRadius = 50.0
            println("DVC Lifecycle viewDidLoad 06")
        
        
        if self.selectedPerson?.imageFor.imageAsset == nil {
                println("DVC Lifecycle viewDidLoad 07")
            self.imageView.image = UIImage(named: "stack21")
                println("DVC Lifecycle viewDidLoad 08")

        } else {
        
            println("DVC Lifecycle viewDidLoad 09")
        var loadedImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
            println("DVC Lifecycle viewDidLoad 10")
        self.imageView.image = loadedImage
            println("DVC Lifecycle viewDidLoad 11")
        }
            println("DVC Lifecycle viewDidLoad 12")
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
            println("DVC Lifecycle viewWillAppear 01")

        if self.selectedPerson?.isTeacher == false {
            instructorSwitch.setOn(false, animated: true)
        }

    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if (selectedPerson? != nil) {
//            self.selectedPerson?.firstName = self.firstNameField.text
//            self.selectedPerson?.lastName = self.lastNameField.text
//            self.selectedPerson?.imageFor = self.imageView.image
//            
//            if instructorSwitch.on {
//                self.selectedPerson?.isTeacher = true
//            } else {
//                self.selectedPerson?.isTeacher = false
//            }
//            
//        } else {
//            
//            println("ugh")
//            
//            if self.firstNameField.text.isEmpty && self.lastNameField.text.isEmpty {
//                println("first name empty is \(self.firstNameField.text.isEmpty)")
//                println("last name empty is \(self.lastNameField.text.isEmpty)")
//                println("M T DOOOOOOOOOOOOO00000000D")
//            } else {
//                var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
//                newPerson.setValue(self.firstNameField.text, forKey: "firstName")
//                newPerson.setValue(self.lastNameField.text, forKey: "lastName")
//                
//                if self.imageView.image != nil {
//                    newPerson.setValue(self.imageView.image, forKey: "imageFor")
//                    
//                }
//                
//                if instructorSwitch.on {
//                    newPerson.setPrimitiveValue(true, forKey: "isTeacher")
//                } else {
//                    newPerson.setPrimitiveValue(false, forKey: "isTeacher")
//                }
//                selectedPerson? = newPerson as Person
//            }
//            
//        }
//        
//        println("is this a teacher? \(self.selectedPerson?.isTeacher)")

    }
    
    @IBAction func cancelUnwind(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    @IBAction func saveDis(sender: UIBarButtonItem) {
        if (selectedPerson? != nil) {
            editPerson()
            
        } else {
            createPerson()
        }
        
        dismissViewController()
    }
    
    func editPerson() {
            self.selectedPerson?.firstName = self.firstNameField.text
            self.selectedPerson?.lastName = self.lastNameField.text
            self.selectedPerson?.imageFor = self.imageView.image
            
            if instructorSwitch.on {
                self.selectedPerson?.isTeacher = true
            } else {
                self.selectedPerson?.isTeacher = false
            }
            println("is this a teacher? \(self.selectedPerson?.isTeacher)")
        }
    func createPerson() {
        
            if self.firstNameField.text.isEmpty && self.lastNameField.text.isEmpty {
                println("first name empty is \(self.firstNameField.text.isEmpty)")
                println("last name empty is \(self.lastNameField.text.isEmpty)")
                println("M T DOOOOOOOOOOOOO00000000D")
            } else {
                var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
                newPerson.setValue(self.firstNameField.text, forKey: "firstName")
                newPerson.setValue(self.lastNameField.text, forKey: "lastName")
                
                if self.imageView.image != nil {
                    newPerson.setValue(self.imageView.image, forKey: "imageFor")
                    
                }
                
                if instructorSwitch.on {
                    newPerson.setPrimitiveValue(true, forKey: "isTeacher")
                } else {
                    newPerson.setPrimitiveValue(false, forKey: "isTeacher")
                }
                selectedPerson? = newPerson as Person
            }
            println("is this a teacher? \(self.selectedPerson?.isTeacher)")
        }
        



//    override func segueForUnwindingToViewController(toViewController: UIViewController!, fromViewController: UIViewController!, identifier: String!) -> UIStoryboardSegue! {
//        let seg = super.segueForUnwindingToViewController(ViewController(), fromViewController: DetailViewController(), identifier: "create")
//        println("i am here")
//
//        
//        if (selectedPerson? != nil) {
//            self.selectedPerson?.firstName = self.firstNameField.text
//            self.selectedPerson?.lastName = self.lastNameField.text
//            self.selectedPerson?.imageFor = self.imageView.image
//            
//            if instructorSwitch.on {
//                self.selectedPerson?.isTeacher = true
//            } else {
//                self.selectedPerson?.isTeacher = false
//            }
//            
//        } else {
//            
//            
//            println("ugh")
//            
//            if self.firstNameField.text.isEmpty && self.lastNameField.text.isEmpty {
//                println("first name empty is \(self.firstNameField.text.isEmpty)")
//                println("last name empty is \(self.lastNameField.text.isEmpty)")
//                println("M T DOOOOOOOOOOOOO00000000D")
//            } else {
//                var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
//                newPerson.setValue(self.firstNameField.text, forKey: "firstName")
//                newPerson.setValue(self.lastNameField.text, forKey: "lastName")
//                
//                if self.imageView.image != nil {
//                    newPerson.setValue(self.imageView.image, forKey: "imageFor")
//                    
//                }
//                
//                if instructorSwitch.on {
//                    newPerson.setPrimitiveValue(true, forKey: "isTeacher")
//                } else {
//                    newPerson.setPrimitiveValue(false, forKey: "isTeacher")
//                }
//                selectedPerson? = newPerson as Person
//            }
//            
//        }
//        
//        println("is this a teacher? \(self.selectedPerson?.isTeacher)")
//        
//        return seg
//    }

    override func didReceiveMemoryWarning() {
            println("DVC Lifecycle didReceiveMemoryWarning 01")
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
            println("DVC Lifecycle textFieldShouldReturn 01")
        textField.resignFirstResponder()
            println("DVC Lifecycle textFieldShouldReturn 02")
        return true
    }
    
    
//    #MARK: Input management
    
    @IBAction func tryThis() {
        println("did it work?")
    }

    
    @IBAction func instructorSwitchSwitched(sender: UISwitch) {
        if instructorSwitch.on {
            println("on")
        } else {
            println("off")
        }
    }
    
    @IBAction func photoButtonPressed(sender: UIButton) {
        self.holdThis()
            println("DVC6")
        var imagePickerController = UIImagePickerController()
            println("DVC7")
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum // .camera
            println("DVC8")
        self.presentViewController(imagePickerController, animated: true, completion: nil /* for some code*/)
            println("DVC9")
        imagePickerController.delegate = self
            println("DVC10")
        imagePickerController.allowsEditing = true
    }

    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        // gets fired when image picker is done
        println("user picked an image")
        
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        self.imageView.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        // fired when user cancels
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func holdThis() {
        var alert = UIAlertController(title: "Title", message: "message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) in
                println("things here")
            })
        alert.addAction(UIAlertAction(title: "Load from library", style: UIAlertActionStyle.Destructive) {
            (action) in
            println("stuff here")
            //code to choose library here
        })
    }
    
    func dismissViewController() {
        navigationController.popViewControllerAnimated(true)
    }
    
//    func presentCamera()
//    {
//        // Check for the camera device
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
//        {
//            println("YES")
//            var cameraUI = UIImagePickerController()
//            cameraUI.delegate = self
//            cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            
//            // If true you can pinch and zoom to make a diffrent image
//            cameraUI.allowsEditing = true
//            // Pops the camera UI on screen
//            self.presentViewController(cameraUI, animated: true, completion: nil)
//        }
//        else
//        {
//            var alert = UIAlertView()
//            alert.title = "No Device"
//            alert.message = "Your device does not have the proper camera"
//            alert.addButtonWithTitle("OK")
//            alert.show()
//        }
//        
//        
//    }

}
