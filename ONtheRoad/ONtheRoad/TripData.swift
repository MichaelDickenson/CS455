import UIKit
import CoreLocation
import MapKit
import CoreData

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
    
    func addCLLocation(location: CLLocation)
    {
        var tempLocation: [Location]
        
        //Getting the timestamp
            tempLocation?.timeStamp = location.timestamp
        //Getting the lat
            tempLocation?.latitude = location.coordinate.latitude
        //Getting the long
            tempLocation?.longitude = location.coordinate.longitude
        //Getting the distance
        //Can't remember this fucker
        
        //Getting the instSpeed
            tempLocation?.instSpeed = location.distance(from: locations.last!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
        //Getting the instAccel
            tempLocation?.instAccel = ((tempLocation?.instSpeed)! - (tripLocationData.last?.instSpeed)!)/location.timestamp.timeIntervalSince((locations.last?.timestamp)!)
        //Getting the effRatio
            tempLocation?.efficiencyRatio = tempLocation?.instAccel/(vehicleMaxAccel/2)
    }
    
}

class Location {
    //Mandatory Variables
    var timeStamp: Date
    var latitude: Double
    var longitude: Double
    var distance: Double
    
    //Derived Variables
    var instSpeed: Double = 0
    var instAccel: Double = 0
    var efficiencyRatio: Double = 0
    
    init?(timeStamp: Date, latitude: Double, longitude: Double, distance: Double){
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
    }
    
}
