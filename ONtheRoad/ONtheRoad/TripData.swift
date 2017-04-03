import UIKit
import CoreLocation

class TripData: NSObject, CLLocationManagerDelegate{
    
    //Mandatory Variables
    var locationManager: CLLocationManager!
    var startTime: Date?
    var vehicleID: Int
    var started = 0
    
    //Optional Input Variables
    var name: String?
    var odometerStart: Int?
    var vehicleMaxAccel: Double?
    
    //End of Trip Variables
    var odometerEnd: Int?
    var endTime: Date?
    var tripLength: Double?
    var tripDistance: Double = 0
    
    var tripLocationData = [Location]()
    
    init?(vehicleID: Int, name: String?, odometerStart: Int?, vehicleMaxAccel: Double?){
        self.startTime = Date.init()
        self.vehicleID = vehicleID
        self.name = name
        self.odometerStart = odometerStart
        self.vehicleMaxAccel = vehicleMaxAccel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //func startLocationUpdates()
    func startTrip(){
        tripLocationData.append(Location.init(timeStamp: Date.init(), latitude: 0, longitude: 0)!)
        started = 1
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType =
            .automotiveNavigation
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        print("Trip Started")
        locationManager.startUpdatingLocation()
    }
    
    func endTrip(){
        started = 0
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
            if locations.count > 0 {
                let tempLocation = Location(timeStamp: location.timestamp, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                print(location.coordinate.latitude)
                print(location.coordinate.longitude)
                
                tempLocation?.instSpeed = location.distance(from: locations.last!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
                tempLocation?.distanceSinceLast = location.distance(from: locations.last!)
                tempLocation?.instAcceleration = ((tempLocation?.instSpeed)! - (tripLocationData.last?.instSpeed)!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
                
                tripDistance = tripDistance + (tempLocation?.distanceSinceLast)!
                
                print ("s: ", tempLocation?.instSpeed)
                print ("d: ", tempLocation?.distanceSinceLast)
                print ("a: ", tempLocation?.instAcceleration)
                
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
    var instSpeed: Double = 0
    var distanceSinceLast: Double = 0
    var instAcceleration: Double = 0
    var efficiencyRatio: Double = 0
    
    init?(timeStamp: Date, latitude: Double, longitude: Double){
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
