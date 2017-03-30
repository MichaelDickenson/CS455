//
//  AddVehicleViewController.swift
//  ONtheRoad
//
//  Created by Santiago Félix Cárdenas on 2017-03-29.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewColors()
    }
    
    // MARK: Actions
    
    @IBAction func vehicleNameAction(_ sender: UITextField) {
        if vehicleName.text! != "" {
            vehicleName.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
            vehicleName.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
            vehicleName.layer.borderWidth = 1.0
            vehicleName.layer.cornerRadius = 5.0
        }
    }
    
    @IBAction func makeSegueAction(_ sender: UITextField) {
        resignFirstResponder()
        //isEditing = false
        vehicleModel.allowsEditingTextAttributes = false
        
        self.performSegue(withIdentifier: "makeSegue", sender: nil)
    }
    
    @IBAction func modelSegueAction(_ sender: UITextField) {
        
        resignFirstResponder()
        //isEditing = false
        vehicleModel.allowsEditingTextAttributes = false
        
        self.performSegue(withIdentifier: "modelSegue", sender: nil)
        
        /*func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let destinationViewController: ModelTableViewController = segue.destination as? ModelTableViewController {
         //destinationViewController.vehiclesList = VehicleProfileData.vehicleData//vehiclesList// selectedMake = vehicleMake.text!
         }
         }*/
    }
    
    @IBAction func yearSegue(_ sender: UITextField) {
        resignFirstResponder()
        vehicleYear.allowsEditingTextAttributes = false
        
        self.performSegue(withIdentifier: "yearSegue", sender: nil)
    }
    
    @IBAction func trimSegue(_ sender: UITextField) {
        resignFirstResponder()
        vehicleTrim.allowsEditingTextAttributes = false
        
        self.performSegue(withIdentifier: "trimSegue", sender: nil)
    }
    
    @IBAction func unwindToVehicleProfile(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MakeTableViewController, var returnedMake = sourceViewController.returnThis {
            if returnedMake == "Label" {
                returnedMake = "Acura"
            }
            vehicleMake.text = returnedMake
            vehicles = VehicleProfile(name: vehicleName.text!, make: returnedMake, model: "", year: "", trim: "", type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].make = returnedMake

            if vehicleMake.text! != "Label" {
                vehicleMake.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleMake.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleMake.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleMake.layer.borderWidth = 1.0
                vehicleMake.layer.cornerRadius = 5.0
            }
        }
        
        if let sourceViewController = sender.source as? ModelTableViewController, let returnedModel = sourceViewController.returnThis {
            vehicleModel.text = returnedModel
            vehicles = VehicleProfile(name: vehicleName.text!, make: vehicleMake.text!, model: returnedModel, year: "", trim: "", type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].model = returnedModel
            
            if vehicleModel.text! != "Label" {
                vehicleModel.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleModel.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleModel.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleModel.layer.borderWidth = 1.0
                vehicleModel.layer.cornerRadius = 5.0
            }
        }
        
        if let sourceViewController = sender.source as? YearTableViewController, let returnedYear = sourceViewController.returnThis {
            vehicleYear.text = returnedYear
            vehicles = VehicleProfile(name: vehicleName.text!, make: vehicleMake.text!, model: vehicleModel.text!, year: returnedYear, trim: "", type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].year = returnedYear
            
            if vehicleYear.text! != "Label" {
                vehicleYear.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleYear.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleYear.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleYear.layer.borderWidth = 1.0
                vehicleYear.layer.cornerRadius = 5.0
            }
        }
        
        if let sourceViewController = sender.source as? TrimTableViewController, let returnedTrim = sourceViewController.returnThis {
            vehicleTrim.text = returnedTrim
            vehicles = VehicleProfile(name: vehicleName.text!, make: vehicleMake.text!, model: vehicleModel.text!, year: vehicleTrim.text!, trim: returnedTrim, type: "", id: "")
            VehicleProfileData.vehicleData.append(vehicles!)
            //VehicleProfileData.vehicleData[0].trim = returnedTrim
            
            if vehicleTrim.text! != "Label" {
                vehicleTrim.textColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0)
                vehicleTrim.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleTrim.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
                vehicleTrim.layer.borderWidth = 1.0
                vehicleTrim.layer.cornerRadius = 5.0
            }
        }
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Functions
    
    func setViewColors() {
        // Round corners for profile image
        self.vehicleImage.layer.cornerRadius = self.vehicleImage.frame.size.height / 2
        self.vehicleImage.clipsToBounds = true
        // Border for image
        self.vehicleImage.layer.borderWidth = 2.0
        self.vehicleImage.layer.borderColor = UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0).cgColor
    }
}
