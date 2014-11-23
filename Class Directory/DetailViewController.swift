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

// ---------------------------------------------------------------------------
//  #MARK: Outlets
// ---------------------------------------------------------------------------

  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var gitHubUserNameField: UITextField!
  @IBOutlet weak var instructorSwitch: UISwitch!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

// ---------------------------------------------------------------------------
//  #MARK: Variables
// ---------------------------------------------------------------------------

  let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

  var selectedPerson : Person?
  var firstFieldBool : Bool = false
  var lastFieldBool : Bool = false
  var customImage = false
  var gitHubAPIUrl = "https://api.github.com/users/"
  var jsonData : NSDictionary?
  var imageType : Int? // 0 for default, 1 for custom image, 2 for GitHub image

// ---------------------------------------------------------------------------
//  #MARK: Lifecycle
// ---------------------------------------------------------------------------

  override func viewDidLoad() {
    super.viewDidLoad()

    firstNameField.delegate = self
    lastNameField.delegate = self

    // Check what image to display for the person

    if self.selectedPerson?.imageFor?.imageAsset != nil{
      println("is an image")
      self.imageView.image = self.selectedPerson?.imageFor!
      self.imageType = self.selectedPerson?.imageSource
      println("imageType, imageSource  \(self.imageType), \(self.selectedPerson?.imageSource)")
    } else {
      setDefaultImage()
    }
    // Turn theSave button on or off depending on whether the person is loading or being created
    if selectedPerson? == nil {
      self.navigationItem.rightBarButtonItem?.enabled = false
    } else {
      self.navigationItem.rightBarButtonItem?.enabled = true
    }
    // Set the bool values used throughout the Detail VC to determine whether the save button is enabled
    // Can'seem to successfully detect the length of the strings programmatically, runtime bug?
    if self.selectedPerson?.firstName != nil {
      firstFieldBool = true
    }
    if self.selectedPerson?.lastName != nil {
      lastFieldBool = true
    }
    // Populate the text fields
    self.firstNameField.text = self.selectedPerson?.firstName
    self.lastNameField.text = self.selectedPerson?.lastName
    self.gitHubUserNameField?.text = self.selectedPerson?.gitHubUserName
    self.imageView.layer.masksToBounds = true
    self.imageView.layer.cornerRadius = 5.0
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    // Set the state of the instructor switch based on the isTeacher key in the data model
    if self.selectedPerson?.isTeacher == false {
      instructorSwitch.setOn(false, animated: true)
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }

  func dismissViewController() {
    // Close the current VC
    navigationController?.popViewControllerAnimated(true)
  }

// ---------------------------------------------------------------------------
//  #MARK: Data Management
// ---------------------------------------------------------------------------

  func editPerson() {
    // Edit an existing entry
    self.selectedPerson?.firstName = self.firstNameField.text
    self.selectedPerson?.lastName = self.lastNameField.text

    if self.imageType != 0 {
      self.selectedPerson?.imageFor = self.imageView.image!
      self.selectedPerson?.imageSource = self.imageType!
    } else {
      self.selectedPerson?.imageSource = self.imageType!
      self.selectedPerson?.imageFor = nil
    }
    // Only save the GitHub Username if there is actually text in it, nil check didn't work for some reason
    if self.lengthBool(self.gitHubUserNameField.text) == true {
      self.selectedPerson?.gitHubUserName = self.gitHubUserNameField.text
    }
    // Set the isTeacher property for the entity depending on the state of the Instructor Switch
    if instructorSwitch.on {
      self.selectedPerson?.isTeacher = true
    } else {
      self.selectedPerson?.isTeacher = false
    }
  }

  func createPerson() {

    if self.firstNameField.text.isEmpty && self.lastNameField.text.isEmpty {
      println("First and last name fields are empty, I won't save: this should never appear any more")
    } else {
      var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context!) as NSManagedObject
      newPerson.setValue(self.firstNameField.text, forKey: "firstName")
      newPerson.setValue(self.lastNameField.text, forKey: "lastName")

      if self.lengthBool(self.gitHubUserNameField.text) == true {
        newPerson.setValue(self.gitHubUserNameField.text, forKey: "gitHubUserName")
      } else {
        newPerson.setNilValueForKey("gitHubUserName")
      }

      if self.imageType != 0 {
        newPerson.setValue(self.imageView.image, forKey: "imageFor")
        newPerson.setValue(self.imageType, forKey: "imageSource")
      } else {
        newPerson.setNilValueForKey("imageFor")
        newPerson.setValue(self.imageType, forKey: "imageSource")
      }

      if instructorSwitch.on {
        newPerson.setPrimitiveValue(true, forKey: "isTeacher")
      } else {
        newPerson.setPrimitiveValue(false, forKey: "isTeacher")
      }
      self.selectedPerson? = newPerson as Person
    }
  }

  // Here we set the image from the imagePicker/camera
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
    var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
    self.changeImage(editedImage)
    self.imageType = 1
    picker.dismissViewControllerAnimated(true, completion: nil)
  }

// ---------------------------------------------------------------------------
//  #MARK: Interface Elements
// ---------------------------------------------------------------------------

  @IBAction func cancelUnwind(sender: UIBarButtonItem) {
    // Press the Cancel button in the Nav Bar
    dismissViewController()
  }

  @IBAction func saveDis(sender: UIBarButtonItem) {
    // Press the Sav button in the Nav Bar, choose a method based on whether this is a new person or not
    if (selectedPerson? != nil) {
      editPerson()
    } else {
      createPerson()
    }
    dismissViewController()
  }

  @IBAction func instructorSwitchSwitched(sender: AnyObject) {
    // Watch for the user tapping the Insturctor switch and change the default image if there is no custom image
    if instructorSwitch.on {
      if self.imageType == 0 {
        self.changeImage(UIImage(named:"teacher")!)
      }
    } else {
      if self.imageType == 0 {
        self.changeImage(UIImage(named: "student")!)
      }
    }
  }

  @IBAction func photoButtonPressed(sender: AnyObject) {
    var imagePickerController = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
    }

    if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
    }

    self.presentViewController(imagePickerController, animated: true, completion: nil)
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
  }

  @IBAction func didTap(sender: UITapGestureRecognizer) {
    // Watches for input via the user tapping the UIImage
    self.tapPicture()
  }

  func changeImage(withImage: UIImage) {
    UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
      self.imageView.image = withImage
      }, completion: nil)
  }

  func setDefaultImage () {
    if self.selectedPerson?.isTeacher == true   {
      self.imageView.image = UIImage(named: "teacher")
      self.imageType = 0
    } else if self.selectedPerson?.isTeacher == false {
      self.imageView.image = UIImage(named: "student")
      self.imageType = 0
    } else {
      self.imageView.image = UIImage(named: "teacher")
      self.imageType = 0
    }
  }

// ---------------------------------------------------------------------------
//  #MARK: Input Management
// ---------------------------------------------------------------------------

  func textFieldShouldReturn(textField: UITextField!) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
    // Check which text field is being edited and set variables to allow the DetailVC to disable the save button later in the method
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
      println("user is editing a field that doesn't enable or disable the save button")
    }

    // Disable the Save button if both first and last name fields are empty
    if firstFieldBool == false && lastFieldBool == false {
      println("CASE 1 \(firstFieldBool.boolValue), \(lastFieldBool.boolValue)")
      self.navigationItem.rightBarButtonItem?.enabled = false
    } else {
      println("CASE 2 \(firstFieldBool.boolValue), \(lastFieldBool.boolValue)")
      self.navigationItem.rightBarButtonItem?.enabled = true
    }
    // And we're done
    return true
  }

  func textFieldShouldClear(textField: UITextField!) -> Bool {
    // Disable the Save button if pressing the clear button will leave both First and Last Name fields empty
    if textField == firstNameField {
      self.firstFieldBool = false
      if self.lastNameField.text.isEmpty {
        self.navigationItem.rightBarButtonItem?.enabled = false
      }
    } else if textField == lastNameField {
      self.lastFieldBool = false
      if self.firstNameField.text.isEmpty {
        self.navigationItem.rightBarButtonItem?.enabled = false
      }
    }
    return true
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }

  func lengthMine(testString: String) -> Int {
    //return a string length because String doesn't have a .length method
    let lengthIs = countElements(testString)
    return lengthIs
  }

  func lengthBool(testString: String) -> Bool {
    //return a bool, like .isEmpty but I wrote it, it is mine, my precious, with fewer variables being declared
    let lengthIs = countElements(testString)
    if lengthIs > 0 {
      return true
    } else {
      return false
    }
  }

// ---------------------------------------------------------------------------
//  #MARK: User Communication
// ---------------------------------------------------------------------------

  func tapPicture() {
    var alert = UIAlertController(title: "Picture", message: "Choose a picture source", preferredStyle: UIAlertControllerStyle.ActionSheet)
    var conversionString : String?
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Take Picture", style: UIAlertActionStyle.Default, handler: {
      UIAlertAction in
      self.photoButtonPressed(self)
    }))
    alert.addAction(UIAlertAction(title: "Use Github Image", style: UIAlertActionStyle.Default, handler: {
      UIAlertAction in
      if self.lengthBool(self.gitHubUserNameField.text) == true {
        var url = NSURL(string: "\(self.gitHubAPIUrl)\(self.gitHubUserNameField.text)")
        self.getJSONDataFromGitHub(self.gitHubUserNameField.text)
      } else {
        self.genericAlert("Need Username", message: "Please enter a GitHub Username to download a Github Profile Image", alertStyle: UIAlertControllerStyle.Alert)
      }
    }))
    if self.imageType != 0 {
      alert.addAction(UIAlertAction(title: "Clear Image", style: UIAlertActionStyle.Destructive, handler: {
        UIAlertAction in

        self.imageType = 0
        self.instructorSwitchSwitched(self)
      }))
    }

    self.presentViewController(alert, animated: true, completion: nil)

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
    })
    self.presentViewController(alert, animated: true, completion: nil)
  }

  func genericAlert(title: String, message: String, alertStyle: UIAlertControllerStyle)
  {
    let alertGeneric = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
    alertGeneric.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    }))
    presentViewController(alertGeneric, animated: true, completion: nil)
  }

// ---------------------------------------------------------------------------
//  #MARK: GitHub Integration
// ---------------------------------------------------------------------------

  func getJSONDataFromGitHub(username:String) {
    println("calling for JSON data")
    let URL = NSURL(string: "https://api.github.com/users/\(username)")
    let session = NSURLSession.sharedSession()
    self.activityIndicator.startAnimating()

    let task = session.dataTaskWithURL(URL!, completionHandler: { (data, response, error) -> Void in
      if response == nil {
        self.activityIndicator.stopAnimating()
        self.genericAlert("Page Not Found:", message: "Check your username and try again.", alertStyle: UIAlertControllerStyle.Alert)
      } else {
        let serverResponse = response as NSHTTPURLResponse
        let statusCode = serverResponse.statusCode as Int
        println("status code is \(statusCode)")

        if error != nil {
          println("ERROR fetching JSON from GitHub: \(error.localizedDescription)")
        }
        var errorJSON: NSError?

        if statusCode == 200 {
          var jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJSON) as NSDictionary
          let imageURL = NSURL(string: jsonResults["avatar_url"] as String)
          let imageData = NSData(contentsOfURL: imageURL!)
          let imageFromGitHub = UIImage(data: imageData!)

          dispatch_async(dispatch_get_main_queue(), {
            self.jsonData = jsonResults
            self.changeImage(imageFromGitHub!)
            self.activityIndicator.stopAnimating()
            self.imageType = 2
          })
        } else {
          self.activityIndicator.stopAnimating()
          self.genericAlert("Page Not Found:", message: "Check your username and try again.", alertStyle: UIAlertControllerStyle.Alert)
        }
      }
    })
    task.resume()
  }

}  // End
