//
//  DashboardViewController.swift
//  ONtheRoad
//
//  Created by Santiago Félix Cárdenas on 2017-03-27.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import HealthKit
import CoreLocation

class DashboardViewController: UIViewController, UIScrollViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var newTrip: TripData?
    lazy var stopWatch = Timer()
    var startTime = TimeInterval()
    var seconds = 0
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: GPS
    
    
    //Starts the trip
    func startTrip(){
        tripLocationData.append(Location.init(timeStamp: Date.init(), latitude: 0, longitude: 0)!)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        print("Trip Started")
        locationManager.startUpdatingLocation()
    }
    
    //Stops the trip
    func endTrip(){
        locationManager.stopUpdatingLocation()
        self.endTime = Date.init()
        self.tripLength = self.endTime?.timeIntervalSince(self.startTime!)
        self.odometerEnd = self.odometerStart! + Int(self.tripDistance)
    }
    
    //locationManager() is called everytime the GPS updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //for each location the GPS returns, update tripLocationData with a new Location
        for location in locations{
            
            //Bananas are delicious
            print ("BANANAS")
            //print (self.locations.count)
            
            //If locations is not empty, calculate all
            if self.locations.count > 0 {
                newTrip?.addCLLocation(location: self.location)
                print(location.coordinate.latitude)
                print(location.coordinate.longitude)
            }
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func startStopButton(_ sender: UIButton) {
        
        if startStopButton.currentTitle == "Start" {
            startStopButton.setTitle("Stop", for: .normal)
            
            newTrip = TripData.init(vehicleID: 1, name: "", odometerStart: 0, vehicleMaxAccel: 4.8)
             newTrip?.startTrip()
            
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
        timeLabel.text = String(format: "%02d", h) + ":" + String(format: "%02d", m) + ":"+String(format: "%02d", s)
       // print(newTrip?.tripLocationData[(newTrip?.tripLocationData.count)!-1].instAcceleration)
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}






