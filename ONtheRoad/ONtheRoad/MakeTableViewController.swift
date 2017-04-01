//
//  MakeTableViewController.swift
//  VehiclesAPI
//
//  Created by Santiago Félix Cárdenas on 2017-02-16.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import os.log

class MakeTableViewController: UITableViewController {

    var makeNames = [String]()
    var makesNumber: Int = 0
    var selectedIndex = 0
    var selectedMake = ""
    var returnThis: String?
    
    var specsArray = [String]()
    var specsArray2 = [String]()
    var temp1 = ""
    var temp2 = ""
    var horsepower = ""
    var torque = ""
    var size = ""
    var cylinder = ""
    var fuel = ""

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedStyleID = "101353967"
        
        let urlBase = "https://api.edmunds.com/api/vehicle/v2/styles/"
        let urlExtra = "/equipment?fmt=json&api_key=8zc8djuwwteevqe9nea3cejq"
        let fullURL = URL(string: "\(urlBase)\(selectedStyleID)\(urlExtra)")
        
        do {
            let specs = try Data(contentsOf: fullURL!)
            let allSpecs = try JSONSerialization.jsonObject(with: specs, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            if let aryJSON = allSpecs["equipment"] {
                for index in 0...aryJSON.count-1 {
                    
                    let equipment = aryJSON[index] as! [String : AnyObject]
                    //print("*****************************************************************************")
                    temp1 = equipment["name"] as! String
                    let attr = equipment["attributes"] as! NSArray
                    let temp3 = attr[0] as! [String : AnyObject]
                    let temp4 = temp3["name"] as! String
                    print(temp1)
                    //print(index)
                    print(temp4)
                    
                    
                    
                    if temp1 == "Ege Combined Mpg" {
                        
                        specsArray.append((equipment["name"]! as? String)!)
                        print(specsArray)

                    }
                }
            }
        }
            
        catch {
            
        }
    
        //downloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.makeNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "makeTableViewCell", for: indexPath) as? MakeTableViewCell
        
        if(indexPath.row == selectedIndex) {
            cell?.accessoryType = .checkmark;
            selectedMake = (cell?.makeLabel.text)!
        } else {
            cell?.accessoryType = .none;
        }
        
        cell?.makeLabel.text = self.makeNames[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row;
        self.tableView.reloadData()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            os_log("The done button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        if selectedMake == "Label" {
            selectedMake = makeNames[0]
        }
        returnThis = selectedMake
        //vehicles = VehicleProfile(name: "", make: selectedMake, model: "", year: "", trim: "", type: "")
    }
    
    // MARK: Actions
    
    
    func downloadData() {

        let url = URL(string:"https://api.edmunds.com/api/vehicle/v2/makes?state=new&year=2017&view=basic&fmt=json&api_key=b3aa4xkn4mc964zcpnzm3pmv")
        
        do {
            let allMakesNames = try Data(contentsOf: url!)
            let allMakes = try JSONSerialization.jsonObject(with: allMakesNames, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            if let aryJSON = allMakes["makes"] {
                 //makeNames = ["Select one..."]
                
                for index in 0...aryJSON.count-1 {
                    
                    let makes = aryJSON[index] as! [String : AnyObject]
                    makeNames.append(makes["name"]!.capitalized as String)
                    //stateArray.append(false)
                }
            }
        }
            
        catch {
            
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
