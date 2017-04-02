import UIKit
import CoreLocation

class TripData: NSObject, CLLocationManagerDelegate{
    
    //Mandatory Variables
    var startTime: Date?
    var vehicleID: Int
    
    //Optional Input Variables
    var name: String?
    var odometerStart: Int?
    var vehicleMaxAccel: Double?
    
    //End of Trip Variables
    var odometerEnd: Int?
    var endTime: Date?
    var tripLength: Double?
    var tripDistance: Double?
    
    var tripLocationData = [Location]()
    
    init?(vehicleID: Int, name: String?, odometerStart: Int?, vehicleMaxAccel: Double?){
        self.startTime = Date.init()
        self.vehicleID = vehicleID
        self.name = name
        self.odometerStart = odometerStart
        self.vehicleMaxAccel = vehicleMaxAccel
    }
    
    var locationManager: CLLocationManager!
    lazy var locations = [CLLocation]()
    
    //func startLocationUpdates()
    func startTrip(){
        locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
        
    }
    
    func endTrip(){
        locationManager.stopUpdatingLocation()
        self.endTime = Date.init()
        self.tripLength = self.endTime?.timeIntervalSince(self.startTime!)
        self.odometerEnd = self.odometerStart! + Int(self.tripDistance!)
    }
    
    //locationManager() is called everytime the GPS updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //for each location the GPS returns, update tripLocationData with a new Location
        for location in locations{
            
            //Bananas are delicious
            print ("BANANAS")
            
            //If locations is not empty, calculate all
            if self.locations.count > 0 {
                let tempLocation = Location(timeStamp: location.timestamp, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                tempLocation?.instSpeed = location.distance(from: self.locations.last!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
                tempLocation?.distanceSinceLast = location.distance(from:self.locations.last!)
                tempLocation?.instAcceleration = ((tempLocation?.instSpeed)! - (tripLocationData.last?.instSpeed)!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
                
                self.tripDistance = tripDistance! + (tempLocation?.distanceSinceLast)!
                
                //Efficiency Ratio
                tempLocation?.efficiencyRatio = (tempLocation?.instAcceleration)!/self.vehicleMaxAccel!
                
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
    
}
