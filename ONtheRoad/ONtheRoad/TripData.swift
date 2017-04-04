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
    
    func addCLLocation(location: CLLocation, distanceSinceLast: Double)
    {
        let tempLocation = Location()
        
        //Getting the timestamp
            tempLocation.timeStamp = location.timestamp
        //Getting the lat
            tempLocation.latitude = location.coordinate.latitude
        //Getting the long
            tempLocation.longitude = location.coordinate.longitude
        //Getting the distance
            tempLocation.distance = distanceSinceLast
        
        //Getting the instSpeed
            tempLocation.instSpeed = (tempLocation.distance)
        //Getting the instAccel
        if tripLocationData.count > 1 {
            tempLocation.instAccel = tempLocation.instSpeed - self.tripLocationData[tripLocationData.count-1].instSpeed
        }
        //Getting the effRatio
            tempLocation.efficiencyRatio = tempLocation.instAccel/(vehicleMaxAccel!/2)
        
        self.tripLocationData.append(tempLocation)
    }
    
}

class Location {
    //Mandatory Variables
    var timeStamp: Date = Date.init()
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: Double = 0
    
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
    
    init(){
        //Doesnothing
    }
    
}
