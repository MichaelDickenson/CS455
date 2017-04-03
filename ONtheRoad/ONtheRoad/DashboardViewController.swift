//
//  DashboardViewController.swift
//  ONtheRoad
//
//  Created by Santiago Félix Cárdenas on 2017-03-27.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import HealthKit

class DashboardViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    lazy var stopWatch = Timer()
    var startTime = TimeInterval()
    var seconds = 3580
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    @IBAction func startStopButton(_ sender: UIButton) {
        
        if startStopButton.currentTitle == "Start" {
            startStopButton.setTitle("Stop", for: .normal)
            
            stopWatch = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DashboardViewController.updateTime(_stopWatch:)), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        } else {
            startStopButton.setTitle("Start", for: .normal)
            
            stopWatch.invalidate()
            //stopWatch = nil
        }
    }
    
    // MARK: Functions
    
    func updateTime(_stopWatch: Timer) {
        
        seconds += 1
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(seconds))
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: Double(s))
        let minutesQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: Double(m))
        let hoursQuantity = HKQuantity(unit: HKUnit.hour(), doubleValue: Double(h))
        
        if hoursQuantity.description == "0 hr" {
            
            var fullTime = NSMutableAttributedString()
            let myString = hoursQuantity.description + " " + minutesQuantity.description + " " + secondsQuantity.description
            
            fullTime = NSMutableAttributedString(string: myString as
                String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!])
            
            fullTime.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!], range: NSRange(location: 8, length: 3))
            fullTime.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!], range: NSRange(location: 3, length: 4))
            fullTime.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0), range: NSRange(location: 0, length: 8))
            fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 70.0)!, range: NSRange(location: 2, length: 1))
            fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 40.0)!, range: NSRange(location: 5, length: 1))
            
            timeLabel.attributedText = fullTime
            
            
            timeLabel.text = minutesQuantity.description + " " + secondsQuantity.description
        } else {
            timeLabel.text = hoursQuantity.description + " " + minutesQuantity.description + " " + secondsQuantity.description
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    
/*    func setTimer() {
        
        let strMinutes = String(format: "%02i", minutes)
        let strSeconds = String(format: "%02i", seconds)
        let strMilliseconds = String(format: "%02i", milliseconds)
        
        let smallMilliseconds = "\(strMinutes)\(":")\(strSeconds)\(".")\(strMilliseconds)"
        let myString: NSString = smallMilliseconds as NSString
        var fullTime = NSMutableAttributedString()
        
        fullTime = NSMutableAttributedString(string: myString as
            String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!])
        
        fullTime.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0), range: NSRange(location: 0, length: 8))
        fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!, range: NSRange(location: 0, length: 5))
        fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)!, range: NSRange(location: 5, length: 3))
        fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 70.0)!, range: NSRange(
                                location: 2, length: 1))
        fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 40.0)!, range: NSRange(
                                location: 5, length: 1))
        
        timeLabel.attributedText = fullTime
        
        var km = NSMutableAttributedString()
        
        km = NSMutableAttributedString(string: distanceLabel.text! as
            String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 45.0)!])
        km.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 18.0)!, range: NSRange(
            location: 2, length: 2))
        
        distanceLabel.attributedText = km
        
        var vel = NSMutableAttributedString()
        
        vel = NSMutableAttributedString(string: velocityLabel.text! as
            String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 45.0)!])
        vel.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 18.0)!, range: NSRange(
            location: 2, length: 5))
        
        velocityLabel.attributedText = vel
    }*/
}






