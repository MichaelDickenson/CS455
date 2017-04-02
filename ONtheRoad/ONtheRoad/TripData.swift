//
//  TripData.swift
//  ONtheRoad
//
//  Created by Michael Dickenson on 2017-04-01.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import CoreLocation

//Commented out just for you, Santiago
//If you uncomment, it will probably not compile
//Please enjoy your wonderful life.

/*
class TripData: CLLocationManagerDelegate{
    
    //Mandatory Variables
    var startTime: Date?
    var vehicleNumber: Int
    
    
    //Optional User Input Variables
    var name: String?
    var odometerStart: Int?
    
    //End of Trip Variables
    var odometerEnd: Int?
    var endTime: Date?
    var tripLength: Int?
    var tripDistance: Int?
    
    var tripLocationData = [Location]()
    
    init?(vehicleNumber: Int, name: String?, odometerStart: Int?){
        self.startTime = Date.init()
        self.vehicleNumber = vehicleNumber
        self.name = name
        self.odometerStart = odometerStart
    }

    var locationManager: CLLocationManager!
    lazy var locations = [CLLocation]()
    
//func startLocationUpdates()
    func startTrip(){
        locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations{
            print ("BANANAS")
            
            if self.locations.count < 0 {
                let tempLocation = Location(timeStamp: location.timestamp, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                tempLocation?.instSpeed = location.distance(from: self.locations.last!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
                tempLocation?.distanceSinceLast = location.distance(from:self.locations.last!)
                tempLocation?.instAcceleration = ((tempLocation?.instSpeed)! - (tripLocationData.last?.instSpeed)!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
//eff ratio                tempLocation?.efficiencyRatio = vehicleData
                
                //UNFINISHED STUFF GOES HERE
                
                
                
                tripLocationData.append(tempLocation!)
            }
        }
    }
}

class Location {
    //Mandatory Variables
    var timeStamp: Date
    var latitude: Double
    var longitude: Double
    
    //Derived Variables
    var instSpeed: Double?
    var distanceSinceLast: Double?
    var instAcceleration: Double?
    var efficiencyRatio: Double?
    
    init?(timeStamp: Date, latitude: Double, longitude: Double){
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
    }
    
}*/
