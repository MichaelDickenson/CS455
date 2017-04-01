//
//  AddVehicleViewController.swift
//  ONtheRoad
//
//  Created by Santiago Félix Cárdenas on 2017-03-29.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //var vehiclesList = [VehicleProfile]()
    var vehicles: VehicleProfile?
    
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UITextField!
    @IBOutlet weak var vehicleMake: UITextField!
    @IBOutlet weak var vehicleModel: UITextField!
    @IBOutlet weak var vehicleYear: UITextField!
    @IBOutlet weak var vehicleTrim: UITextField!
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var efficiencyLabel: UILabel!
    @IBOutlet weak var horsepowerLabel: UILabel!
    @IBOutlet weak var cylinderLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var torqueLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var addVehicleScroll: UIScrollView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehicleName.delegate = self
        
        // Set up views if editing an existing vehicle.
        if let vehicles = vehicles {
            navigationItem.title = vehicles.name
            vehicleImage.image = vehicles.photo
            vehicleName.text = vehicles.name
            vehicleMake.text = vehicles.make
            vehicleModel.text = vehicles.model
            vehicleYear.text = vehicles.year
            vehicleTrim.text = vehicles.trim
            
            // Still have to add all the vehicle specs at the bottom

        }
        
        setViewColors()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    // MARK: Actions
    
    @IBAction func imageGestureRecognizer(_ sender: UITapGestureRecognizer) {
                
        openActionSheet()
    }
    
    @IBAction func vehicleNameAction(_ sender: UITextField) {
        if vehicleName.text! == "" {
            vehicleMake.isUserInteractionEnabled = false
            vehicleModel.isUserInteractionEnabled = false
            vehicleYear.isUserInteractionEnabled = false
            vehicleTrim.isUserInteractionEnabled = false
        } else {
            vehicleMake.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
            vehicleMake.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
            vehicleMake.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
            vehicleMake.layer.borderWidth = 1.0
            vehicleMake.layer.cornerRadius = 5.0
            
            vehicleMake.isUserInteractionEnabled = true
            vehicleModel.isUserInteractionEnabled = false
            vehicleYear.isUserInteractionEnabled = false
            vehicleTrim.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func makeSegueAction(_ sender: UITextField) {
        vehicleMake.resignFirstResponder()
        vehicleMake.allowsEditingTextAttributes = false
        performSegue(withIdentifier: "makeSegue", sender: nil)
    }
    
    @IBAction func modelSegueAction(_ sender: UITextField) {
        self.vehicleModel.isUserInteractionEnabled = false
        self.performSegue(withIdentifier: "modelSegue", sender: nil)
    }
    
    @IBAction func yearSegue(_ sender: UITextField) {
        self.vehicleYear.isUserInteractionEnabled = false
        self.performSegue(withIdentifier: "yearSegue", sender: nil)
    }
    
    @IBAction func trimSegue(_ sender: UITextField) {
        self.vehicleTrim.isUserInteractionEnabled = false
        self.performSegue(withIdentifier: "trimSegue", sender: nil)
    }
    
    @IBAction func unwindToAddVehicle(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MakeTableViewController, let returnedMake = sourceViewController.returnThis {
            vehicleMake.text = returnedMake
            vehicles = VehicleProfile(photo: vehicleImage.image!, name: vehicleName.text!, make: returnedMake, model: "", year: "", trim: "", type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].make = returnedMake

            if vehicleMake.text! != "Label" && vehicleMake.text! != ""{
                vehicleModel.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleModel.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleModel.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleModel.layer.borderWidth = 1.0
                vehicleModel.layer.cornerRadius = 5.0

                vehicleMake.isUserInteractionEnabled = true
                vehicleModel.isUserInteractionEnabled = true
                vehicleYear.isUserInteractionEnabled = false
                vehicleTrim.isUserInteractionEnabled = false
            } else {
                vehicleMake.text = ""
            }
        }
        
        if let sourceViewController = sender.source as? ModelTableViewController, let returnedModel = sourceViewController.returnThis {
            vehicleModel.text = returnedModel
            vehicles = VehicleProfile(photo: vehicleImage.image!, name: vehicleName.text!, make: vehicleMake.text!, model: returnedModel, year: "", trim: "", type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].model = returnedModel
            
            if vehicleModel.text! != "Label" {
                vehicleYear.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleYear.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleYear.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleYear.layer.borderWidth = 1.0
                vehicleYear.layer.cornerRadius = 5.0
                
                vehicleMake.isUserInteractionEnabled = true
                vehicleModel.isUserInteractionEnabled = true
                vehicleYear.isUserInteractionEnabled = true
                vehicleTrim.isUserInteractionEnabled = false
            } else {
                vehicleModel.text = ""
            }
        }
        
        if let sourceViewController = sender.source as? YearTableViewController, let returnedYear = sourceViewController.returnThis {
            vehicleYear.text = returnedYear
            vehicles = VehicleProfile(photo: vehicleImage.image!, name: vehicleName.text!, make: vehicleMake.text!, model: vehicleModel.text!, year: returnedYear, trim: "", type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].year = returnedYear
            
            if vehicleModel.text! != "Label" {
                vehicleTrim.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleTrim.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleTrim.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleTrim.layer.borderWidth = 1.0
                vehicleTrim.layer.cornerRadius = 5.0
                
                vehicleMake.isUserInteractionEnabled = true
                vehicleModel.isUserInteractionEnabled = true
                vehicleYear.isUserInteractionEnabled = true
                vehicleTrim.isUserInteractionEnabled = true
            } else {
                vehicleYear.text = ""
            }
        }
        
        if let sourceViewController = sender.source as? TrimTableViewController, let returnedTrim = sourceViewController.returnThis {
            vehicleTrim.text = returnedTrim
            vehicles = VehicleProfile(photo: vehicleImage.image!, name: vehicleName.text!, make: vehicleMake.text!, model: vehicleModel.text!, year: vehicleTrim.text!, trim: returnedTrim, type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].trim = returnedTrim
            
            if vehicleTrim.text! == "Label" || vehicleTrim.text! == "" {
                vehicleTrim.text = ""
            }
        }
        
        if let sourceViewController = sender.source as? TrimTableViewController, let returnedID = sourceViewController.returnThisToo {
            vehicles = VehicleProfile(photo: vehicleImage.image!, name: vehicleName.text!, make: vehicleMake.text!, model: vehicleModel.text!, year: vehicleTrim.text!, trim: vehicleTrim.text!, type: "", id: returnedID)
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].trim = returnedTrim
            
            if returnedID == "" {
                vehicleMake.text = ""
                vehicleModel.text = ""
                vehicleYear.text = ""
                vehicleTrim.text = ""
            } else {
                getVehicleSpecifications(styleID: returnedID)
            }
        }
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Use edited representation of image.
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        vehicleImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: Functions
    
    func setViewColors() {
        // Disable scroll view delay of touch 
        addVehicleScroll.delaysContentTouches = false
        
        // Round corners for profile image
        self.vehicleImage.layer.cornerRadius = self.vehicleImage.frame.size.height / 2
        self.vehicleImage.clipsToBounds = true
        
        // Border for image
        self.vehicleImage.layer.borderWidth = 2.0
        self.vehicleImage.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
        
        // Vehicle Name TextField
        vehicleName.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
        vehicleName.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
        vehicleName.layer.borderWidth = 1.0
        vehicleName.layer.cornerRadius = 5.0
        
        // Do not allow to enter info without previous field completed
        vehicleMake.isUserInteractionEnabled = false
        vehicleModel.isUserInteractionEnabled = false
        vehicleYear.isUserInteractionEnabled = false
        vehicleTrim.isUserInteractionEnabled = false
        vehicleTrim.allowsEditingTextAttributes = false
    }
    
    func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = vehicleName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func openActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openCamera = UIAlertAction(title: "Camera", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            self.openCamera()})
        
        let openLibrary = UIAlertAction(title: "Camera Roll", style: .default, handler: {(alert:UIAlertAction!) -> Void in
            self.openPhotoLibrary()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(openCamera)
        optionMenu.addAction(openLibrary)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        
        let alertController = UIAlertController(title: "Camera", message:
            "The camera is not available", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        let src = UIImagePickerControllerSourceType.camera
        
        // Check if camera is available
        guard UIImagePickerController.isSourceTypeAvailable(src)
            else {
                self.present(alertController, animated: true, completion: nil)
                return
        }
        
        guard let arr = UIImagePickerController.availableMediaTypes(for: src)
            else {
                return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = src
        imagePicker.mediaTypes = arr
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func openPhotoLibrary() {
        
        //Let user pick media
        let imagePickerController = UIImagePickerController()
        
        //Do not allow photos to be taken, only picked from media library
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        //Notify view controller that an image is picked
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func getVehicleSpecifications(styleID: String) {
        
        let selectedStyleID = styleID
        var valueKM: Float = 0.0
        
        let urlBase = "https://api.edmunds.com/api/vehicle/v2/styles/"
        let urlExtra = "/equipment?fmt=json&api_key=gjppwybke2wgy6ndafz23cyr" //b3aa4xkn4mc964zcpnzm3pmv, 8zc8djuwwteevqe9nea3cejq, gjppwybke2wgy6ndafz23cyr
        let fullURL = URL(string: "\(urlBase)\(selectedStyleID)\(urlExtra)")
        
        do {
            let specs = try Data(contentsOf: fullURL!)
            let allSpecs = try JSONSerialization.jsonObject(with: specs, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            if let aryJSON = allSpecs["equipment"] {
                for index in 0...aryJSON.count-1 {
                    
                    let equipment = aryJSON[index] as! [String : AnyObject]
                    let sectionName = equipment["name"] as! String
                    
                    if sectionName == "Specifications" {
                        
                        let attr = equipment["attributes"] as! NSArray
                        var aryValues = attr[6] as! [String : AnyObject]
                        //var name = aryValues["name"] as! String
                        var value = aryValues["value"] as! String
                        
                        // Convert String to Int and convert mpg to km/L
                        if let valueNumber = Float(value) {
                            valueKM = 235 / valueNumber
                            print("This is 21 mpg in L/100km")
                            print(valueKM)
                        }
                        
                        let kmLabel = "L/100km"
                        let finalEfficiency = "\(valueKM)\(kmLabel)"
                        efficiencyLabel.text = finalEfficiency
                        
                        aryValues = attr[7] as! [String : AnyObject]
                        //name = aryValues["name"] as! String
                        value = aryValues["value"] as! String
                        
                        // Convert String to Int and convert mpg to km/L
                        if let accelerationTime = Float(value) {
                            let maxAccelerationTime = (96.56 * 0.278) / accelerationTime
                            print("This is the max acceleration time using 7.8s")
                            print(maxAccelerationTime)
                        }
                        
                    }
                    
                    if sectionName == "Engine" {
                        print(index)
                        let cylinder = equipment["cylinder"] as! Int
                        let size = equipment["size"] as! Float
                        let horsepower = equipment["horsepower"] as! Int
                        let torque = equipment["torque"] as! Int
                        let gas = (equipment["type"] as! String).capitalized
                        
                        cylinderLabel.text = "\(cylinder)"
                        sizeLabel.text = "\(size)"
                        horsepowerLabel.text = "\(horsepower)"
                        torqueLabel.text = "\(torque)"
                        gasLabel.text = gas
                        
                    }
                }
            }
        }
            
        catch {
            
        }
    }
}




