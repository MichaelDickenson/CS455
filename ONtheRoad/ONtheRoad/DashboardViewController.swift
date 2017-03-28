//
//  DashboardViewController.swift
//  ONtheRoad
//
//  Created by Santiago Félix Cárdenas on 2017-03-27.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    var stopWatch = Timer()
    var startTime = TimeInterval()
    var hours = 0
    var minutes = 0
    var seconds = 0
    var milliseconds = 0
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    @IBAction func startStopButton(_ sender: UIButton) {
        
        if startStopButton.currentTitle == "Start" {
            startStopButton.setTitle("Stop", for: .normal)
            
            let aSelector: Selector = #selector(DashboardViewController.updateTime)
            stopWatch = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        } else {
            startStopButton.setTitle("Start", for: .normal)
            
            stopWatch.invalidate()
            //stopWatch = nil
        }
    }
    
    // MARK: Functions
    
    func updateTime() {
        
        milliseconds += 1
        
        if milliseconds == 100 {
            milliseconds = 0
            seconds += 1
        }
        
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        
        if minutes == 60 {
            minutes = 0
            hours += 1
        }
        
        let strHours = String(format: "%2i", hours)
        let strMinutes = String(format: "%02i", minutes)
        let strSeconds = String(format: "%02i", seconds)
        let strMilliseconds = String(format: "%02i", milliseconds)
        
        if hours != 0 {
            
            var frame = timeLabel.frame;
            frame.origin.y = 0
            frame.origin.x = 5
            timeLabel.frame = frame;
            
            let smallMilliseconds = "\(strHours)\(":")\(strMinutes)\(":")\(strSeconds)\(".")\(strMilliseconds)"
            let myString: NSString = smallMilliseconds as NSString
            var fullTime = NSMutableAttributedString()
            
            fullTime = NSMutableAttributedString(string: myString as
                String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!])
            fullTime.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)!], range: NSRange(location: 8, length: 3))
            fullTime.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!], range: NSRange(location: 3, length: 4))
            fullTime.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0), range: NSRange(location: 0, length: 8))
            fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 70.0)!, range: NSRange(location: 2, length: 1))
            fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 40.0)!, range: NSRange(location: 5, length: 1))
            
            timeLabel.attributedText = fullTime
        } else {
            let smallMilliseconds = "\(strMinutes)\(":")\(strSeconds)\(".")\(strMilliseconds)"
            let myString: NSString = smallMilliseconds as NSString
            var fullTime = NSMutableAttributedString()
            
            fullTime = NSMutableAttributedString(string: myString as
                String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!])
            fullTime.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)!], range: NSRange(location: 5, length: 3))
            fullTime.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 70.0)!], range: NSRange(location: 3, length: 1))
            fullTime.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 99/255.0, green: 175/255.0, blue: 213/255.0, alpha: 1.0), range: NSRange(location: 0, length: 8))
            fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 70.0)!, range: NSRange(location: 2, length: 1))
            fullTime.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 40.0)!, range: NSRange(location: 5, length: 1))
            
            timeLabel.attributedText = fullTime
        }
    }
    
    func setTimer() {
        
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
            String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 35.0)!])
        km.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 15.0)!, range: NSRange(
            location: 3, length: 3))
        
        distanceLabel.attributedText = km
        
        var vel = NSMutableAttributedString()
        
        vel = NSMutableAttributedString(string: velocityLabel.text! as
            String, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 35.0)!])
        vel.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 15.0)!, range: NSRange(
            location: 3, length: 6))
        
        velocityLabel.attributedText = vel
    }
}






