//
//  DetailViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var selectedPerson : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var gitHubUserNameField: UITextField!
    @IBOutlet weak var instructorSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    
    var firstFieldBool : Bool = false
    var lastFieldBool : Bool = false
    var customImage = false
    var githubImage = false
    var gitHubAPIUrl = "https://api.github.com/users/"
    var jsonData : NSDictionary?
    

    
    
//  #MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.selectedPerson?.profileImage != nil {
            self.customImage = true

        } else if self.selectedPerson?.imageFor != nil {
            self.customImage = true

        } else {
            println("default image")

        }
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        if selectedPerson? == nil{
            self.navigationItem.rightBarButtonItem?.enabled = false
            
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = true
            
        }
        
        if self.selectedPerson?.firstName != nil {
                firstFieldBool = true
        }
        
        if self.selectedPerson?.lastName != nil {
                lastFieldBool = true
            }
        
//        let recognizer = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
//        recognizer.delegate = self
//        view.addGestureRecognizer(recognizer)
        
        self.firstNameField.text = self.selectedPerson?.firstName
        self.lastNameField.text = self.selectedPerson?.lastName
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 30.0
        
        if self.selectedPerson?.profileImage?.imageAsset != nil {
            var loadedImage = self.selectedPerson?.profileImage
            self.imageView.image = loadedImage
            self.customImage == true
        } else if self.selectedPerson?.imageFor.imageAsset != nil {
            var loadedImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
            self.imageView.image = loadedImage
            self.customImage = true

        } else {
            if self.selectedPerson?.isTeacher == true   {
                self.imageView.image = UIImage(named: "teacher")

            } else if self.selectedPerson?.isTeacher == false {
                self.imageView.image = UIImage(named: "student")
                
            } else {
                self.imageView.image = UIImage(named: "teacher")
                
            }
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        if self.selectedPerson?.isTeacher == false {
            instructorSwitch.setOn(false, animated: true)
            
        }
        
        if self.selectedPerson?.gitHubUserName != nil {
            self.gitHubUserNameField.text = self.selectedPerson?.gitHubUserName
            var url = NSURL(string: "\(self.gitHubAPIUrl)\(self.gitHubUserNameField.text)")
            self.getJSONDataFromGitHub(self.gitHubUserNameField.text)
            
        }
    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        
            if self.customImage == true && self.githubImage == true {
                self.selectedPerson?.profileImage = self.imageView.image!
                
            } else if self.customImage == true && self.githubImage == false {
                self.selectedPerson?.imageFor = self.imageView.image!
                
            } else {
                println("it's a default image")
                
            }
            self.selectedPerson?.gitHubUserName = self.gitHubUserNameField.text
        
            if instructorSwitch.on {
                self.selectedPerson?.isTeacher = true
                
            } else {
                self.selectedPerson?.isTeacher = false
                
            }
        
        }
    
    func createPerson() {
        
            if self.firstNameField.text.isEmpty && self.lastNameField.text.isEmpty {
                println("won't save")
                
            } else {
                var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context!) as NSManagedObject
                newPerson.setValue(self.firstNameField.text, forKey: "firstName")
                newPerson.setValue(self.lastNameField.text, forKey: "lastName")

                if self.gitHubUserNameField.text == nil {
                    newPerson.setValue(self.gitHubUserNameField.text, forKey: "gitHubUserName")
                    
                }
                
                if self.customImage == true && self.githubImage == false {
                    newPerson.setValue(self.imageView.image, forKey: "imageFor")
                    
                } else if self.customImage == true && self.githubImage == true {
                        newPerson.setValue(self.imageView.image, forKey: "profileImage")
                    
                } else {
                    println("default image")
                    
                }
                
                if instructorSwitch.on {
                    newPerson.setPrimitiveValue(true, forKey: "isTeacher")
                    
                } else {
                    newPerson.setPrimitiveValue(false, forKey: "isTeacher")
                    
                }
                
                selectedPerson? = newPerson as Person
                
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    
//    #MARK: Input management
    
    @IBAction func instructorSwitchSwitched(sender: UISwitch) {
        if instructorSwitch.on {
            
            if self.selectedPerson?.imageFor == nil && customImage == false {
                UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.imageView.image = UIImage(named: "teacher")
                    }, completion: nil)

            } else {
                println("don't change")
                
            }
            
        } else {
            if self.selectedPerson?.imageFor == nil && customImage == false {

            UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.imageView.image = UIImage(named: "student")
                }, completion: nil)
            } else {
                println("don't change")

            }
            
        }
    }
    
    @IBAction func photoButtonPressed(sender: UIButton) {
        var imagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            
        }
        self.presentViewController(imagePickerController, animated: true, completion: nil /* for some code*/)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func gitButtonHidden(sender: UIButton) {
        addUsername()
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        self.imageView.image = editedImage
        self.customImage = true
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func addUsername() {
        var alert = UIAlertController(title: "Username", message: "Enter a Github Username", preferredStyle: UIAlertControllerStyle.Alert)
        var conversionString : String?
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.Destructive, handler: {
            UIAlertAction in
                let localField = alert.textFields?[0] as UITextField
                self.gitHubUserNameField.text = localField.text!
            
                    self.getJSONDataFromGitHub(localField.text)
            
                UIView.transitionWithView(self.gitHubUserNameField, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.gitHubUserNameField.setNeedsDisplay()
                }, completion: nil)

            }))

        alert.addTextFieldWithConfigurationHandler({ (textFieldAlert: UITextField!) -> Void in
            textFieldAlert.delegate = self
            
            if self.selectedPerson? == nil {
                textFieldAlert.placeholder = "Username"
            } else {
                textFieldAlert.text = self.gitHubUserNameField.text
            }
            
            textFieldAlert.autocapitalizationType = UITextAutocapitalizationType.None
            textFieldAlert.autocorrectionType = UITextAutocorrectionType.No
            
            
            return
        })
        self.presentViewController(alert, animated: true, completion: nil)
        
    
    }
    
    func refreshView () {
        println("Mind you I don't know whether you've really considered the advantages of owning a really fine set of modern encyclopaedias. You know, they can really do you wonders.")
    }

    func dismissViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {

        
        if textField == firstNameField {
            var yesFirst : NSString = (self.firstNameField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if yesFirst.length > 0 {
                firstFieldBool = true
                
            } else {
                firstFieldBool = false
                
            }
            
        } else if textField == lastNameField {
            var yesLast : NSString = (self.lastNameField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if yesLast.length > 0 {
                lastFieldBool = true
                
            } else {
                lastFieldBool = false
                
            }

        } else {
            println("Not a field I care about")
            
        }
        
        if firstFieldBool == false && lastFieldBool == false {
            println("CASE 1 \(firstFieldBool.boolValue), \(lastFieldBool.boolValue)")
            self.navigationItem.rightBarButtonItem?.enabled = false
            
        } else {
            println("CASE 2 \(firstFieldBool.boolValue), \(lastFieldBool.boolValue)")
            self.navigationItem.rightBarButtonItem?.enabled = true
            
        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
            if textField == self.gitHubUserNameField {
            var url = NSURL(string: "\(self.gitHubAPIUrl)\(self.gitHubUserNameField.text)")
            self.getJSONDataFromGitHub(self.gitHubUserNameField.text)
            
        }
    }
    
    func getJSONDataFromGitHub(username:String) {
        let URL = NSURL(string: "https://api.github.com/users/\(username)")
        let session = NSURLSession.sharedSession()
        self.activityIndicator.startAnimating()
        
        let task = session.dataTaskWithURL(URL, completionHandler: { (data, response, error) -> Void in
            if response == nil {
                self.activityIndicator.stopAnimating()
                self.genericAlert("Page Not Found:", message: "Check your username and try again.", alertStyle: UIAlertControllerStyle.Alert)
                
            } else {
                let serverResponse = response as NSHTTPURLResponse
                let statusCode = serverResponse.statusCode as Int
                    println("status code is \(statusCode)")
                
                if error != nil {
                    println(error.localizedDescription)
                }
                
                var errorJSON: NSError?
                
                if statusCode == 200 //the "good" code
                {
                    var jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJSON) as NSDictionary
                    var url = NSURL(string: jsonResults["avatar_url"] as String)
                    var imageData = NSData(contentsOfURL: url)
                    var image = UIImage(data: imageData)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.jsonData = jsonResults
                        self.imageView.image = image
                        self.activityIndicator.stopAnimating()
                        self.customImage = true
                        self.githubImage = true
                        
                    })
                } else {
                    self.activityIndicator.stopAnimating()
                    self.genericAlert("Page Not Found:", message: "Check your username and try again.", alertStyle: UIAlertControllerStyle.Alert)
                    
                }
            }
        })
        task.resume()
        
    }

    
    func genericAlert(title: String, message: String, alertStyle: UIAlertControllerStyle)
    {
        let alertGeneric = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        alertGeneric.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            
        }))
        presentViewController(alertGeneric, animated: true, completion: nil)
        
    }

    
    func textFieldShouldClear(textField: UITextField!) -> Bool {
        if textField == firstNameField {
            self.firstFieldBool = false
            if !self.lastNameField.text.isEmpty {
                println("there is last name text")
                
            } else {
                self.navigationItem.rightBarButtonItem?.enabled = false
                
            }
        } else if textField == lastNameField {
            self.lastFieldBool = false
            if !self.firstNameField.text.isEmpty {
                println("there is first name text")
                
            } else {
                self.navigationItem.rightBarButtonItem?.enabled = false
                
            }
        }

        return true
        
    }

}
