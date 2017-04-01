//
//  YearTableViewController.swift
//  VehiclesAPI
//
//  Created by Santiago Félix Cárdenas on 2017-03-16.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import os.log

class YearTableViewController: UITableViewController {

    var yearString = [Int]()
    //var yearStrings: String = ""
    //var yearNumber: Int = 0
    var selectedIndex = 0
    var selectedMake = ""
    var selectedModel = ""
    var selectedYear = ""
    var returnThis: String? = ""
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //downloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yearString.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearTableViewCell", for: indexPath) as? YearTableViewCell
        
        if(indexPath.row == selectedIndex) {
            cell?.accessoryType = .checkmark;
            selectedYear = (cell?.yearLabel.text)!
        } else {
            cell?.accessoryType = .none;
        }
                
        cell?.yearLabel.text = "\(self.yearString[indexPath.row])"
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
        if selectedYear == "Label" {
            selectedYear = "\(yearString[0])"
        }
        returnThis = "2010"//selectedYear
        //vehicles = VehicleProfile(name: "", make: selectedMake, model: selectedModel, year: "", trim: "", type: "")
    }
    
    //MARK: Actions
    
    
    
    // MARK: Functions
    
    func downloadData() {
        
        //let url = URL(string: "https://api.edmunds.com/api/vehicle/v2/honda/accord/years?&fmt=json&api_key=b3aa4xkn4mc964zcpnzm3pmv")
        
        selectedMake = "honda"//VehicleProfileData.vehicleData[0].make
        selectedModel = "pilot"//VehicleProfileData.vehicleData[0].model
        
        let urlBase = "https://api.edmunds.com/api/vehicle/v2/"
        let urlExtra = "/years?&fmt=json&api_key=gjppwybke2wgy6ndafz23cyr"
        let fullURL = URL(string: "\(urlBase)\(selectedMake)\("/")\(selectedModel)\(urlExtra)")
        
        do {
            
            let allYearStrings = try Data(contentsOf: fullURL!)
            let allYears = try JSONSerialization.jsonObject(with: allYearStrings, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            if let aryJSON = allYears["years"] {
                for index in 0...aryJSON.count-1 {
                    let years = aryJSON[index] as! [String : AnyObject]
                    yearString.append((years["year"]! as? Int)!)

                    //yearStrings = "\(years["year"])"
                    
                    //let start = yearStrings.index(yearStrings.startIndex, offsetBy: 9)
                    //let end = yearStrings.index(yearStrings.endIndex, offsetBy: -1)
                    //let range = start..<end
                    
                    //yearString.append(yearStrings.substring(with: range))
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
