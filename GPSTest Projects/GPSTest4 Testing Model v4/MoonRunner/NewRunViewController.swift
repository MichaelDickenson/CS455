//This file generates the Current Run page. We can cannibalize this for the dashboard map.

//Also contains the function for saving a current run into the CoreData stuff, this will need to be changed in the future
    //see the saverun() func

//If we do not show the real time map on the dashboard we can scrap a lot of the map elements.
    //Will just need to salvage the GPS readings.

//We can use these guys meathods for our HHMMSS, and total distance

//Commenting out AudioToolbox items, we are not using this aspect.

//I have currently commented out the climb and descent items just cause we aren't going to bother displaying them
//If you try to start a run with them disabled the app crashes, to get it to stop crashing just uncomment the IBOutlets
//and the .text items under the Displayed climb item.
//IBOutlets are currently uncommented, going to deal with them some other time as I feel it will require some work in the CoreData and UI to be able to leave them commented without crashing stuff.

import UIKit
import CoreData
import CoreLocation
import HealthKit
import MapKit
//import AudioToolbox

let DetailSegueName = "RunDetails"

class NewRunViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    //This is CoreData shit
    var managedObjectContext: NSManagedObjectContext?
    
    //Need to figure out how to pipe this into a model layout

//*******************
//This is a variable put in by yours truly, it will record whether or not the user has started their trip.
    //If they have not it will be 0.
    //If they have it will be 1.
    //This variable will be used to control whether or not the polyline stuff is going to be drawing a real time line.
    //Without this variable and subsuquent stuff, the user will only see a blue square until they start their trip.
    //Priming this variable to 0.
    //this gets changed in the start and stop UpdatingLocation funcs
    var started = 0
//*******************
//*******************
    
    var run: Run!
    var seconds = 0.0
    var distance = 0.0
    //This is the current measure speed of a segement
    var instantPace = 0.0
    //Going to keep the vertClimb and Descent items, we can pretend that we have them for more advance readings.
    //I actually think it is part of the distance measurement so... yeah
//    var vertClimb = 0.0
//    var vertDescent = 0.0
//    var previousAlt = 0.0
    
//Michael created variables
    //Going to use the outlet for climb to show accel.
    var maxAccel = 4.6 // Using a mazda3 MPS. 0-100 kph in 6.1s. the 0-100 converts to 27.8m/s. We then get 27.8/6.1 for an average acceleration of 4.6m/s^2.
    var accel = 0.0 //Variable for accel, (delta V)/(delta time). (distance/time)/time.
    //Going to use the outlet for descent for consumption
    var carConsumptiion = 24.0 //Cars documented consumption
    var effFactor = 0.0 //Cars current effiency factor
    
    
    var locationManager: CLLocationManager!
    
    //This will be needed to 
    lazy var locations = [CLLocation]()
    lazy var timer = Timer()
    var mapOverlay: MKTileOverlay!
    
    //If we are not using the map on the dashboard all these IBOutlets can be scrapped.
    //If we have a dashboard map, we just need this next one.
    @IBOutlet weak var mapView2: MKMapView!
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
//I'm leaving these climb/descent IBOutlets uncommented as the app crashes when they are commented, commenting everything that updates them
    @IBOutlet weak var climbLabel: UILabel! //Hijacking this outlet plug to show Accel
    @IBOutlet weak var descentLabel: UILabel! //Hijacking this outlet plug to show consumption
    @IBOutlet weak var nextBadgeImageView: UIImageView!
    @IBOutlet weak var nextBadgeLabel: UILabel!
    
  
//Code that displays GPS stuff before the trip has begun.
//If we aren't showing on the dashboard the viewWillAppear and viewDidLoad can be largely scrapped. I think.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startButton.isHidden = false
        promptLabel.isHidden = false
        
        timeLabel.isHidden = true
        distanceLabel.isHidden = true
        paceLabel.isHidden = true
//        climbLabel.isHidden = true
//        descentLabel.isHidden = true
        stopButton.isHidden = true
        
//This controls the map visibility
//Without the started var this is just a blue square.
        mapView2.isHidden = false
        
        
        nextBadgeLabel.isHidden = true
        nextBadgeImageView.isHidden = true

//*******************
//We are going to need this for the dashboard I beleive, even without the map view.
//This is getting GPS to start getting its readings and focusing in on the user, will have this start loading up any time we are on the dashboard. Could in THEORY do it whenever the app is running but that seems a wee bit overkill.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        
        //This guy was formerly set to .fitness as its type
        //I think we lose a bit of accuracy/updating speed with .automotive, not 100% on that. automotiveNavigation
        locationManager.activityType =
            .automotiveNavigation
        
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        
//*******************
//*******************
        
 
//This will get the users current location and display it on a map.
        startLocationUpdates()
//I know I said we'd only flip started in the start and stop UpdateLocations, I lied.
//I want to flip started to 1 in startLocationUpdates func to try to reduce the lag time between the trip starting to record and the line being drawn.
//That means that when the above startLocationUpdates is called the line will start THINKING about drawing but we immeditaly flip the started varaible back to 0 which shuts that line down before it can even start.
//This can be changed and we could move the started = 1 from the startLocationUpdates to startPressed func.
        started = 0
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView2.delegate = self;
        
        mapView2.showsUserLocation = true
    }
   
//*******************
//If no map on dashboard we can largely scrap this code. Starred section only part that needs to be saved if no dash map
//This controls the displayed live map and its zoom level, might need to change it for a smaller size...
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView2.userLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView2.setRegion(coordinateRegion, animated: true)
    }
//*******************
//*******************
  
//Start of a trip, only need to salvage the last bit I think.
    @IBAction func startPressed(_ sender: AnyObject) {
        
        startButton.isHidden = true
        promptLabel.isHidden = true
        
        timeLabel.isHidden = false
        distanceLabel.isHidden = false
        paceLabel.isHidden = false
//        climbLabel.isHidden = false
//        descentLabel.isHidden = false
        stopButton.isHidden = false
        
//Making the map element visible.
        mapView2.isHidden = false
        
        nextBadgeLabel.isHidden = false
        nextBadgeImageView.isHidden = false
        
//*******************
//We will need to attach this stuff to our start button
        seconds = 0.0
        distance = 0.0
//        vertClimb = 0.0
//        vertDescent = 0.0
        instantPace = 0.0
//        previousAlt = -1000
        
        //Adding in the varaible for accel
        accel = 0.0

//MARK: FUCKING HERE
        locations.removeAll(keepingCapacity: false)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(eachSecond(_:)),
                                     userInfo: nil,
                                     repeats: true)
        startLocationUpdates()
//*******************
//*******************
    }
    

//*******************
//Func for stopping the tracking, we could defintely cannibalize this actionsheet.
    @IBAction func stopPressed(_ sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Walk Stopped", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Discard")
        actionSheet.actionSheetStyle = .default
        actionSheet.show(in: view)
        
 
        
//This guy was previously stopping the recording when the user hit Stop. Which seems fine at first, but if the user hit cancel, meaning they wished to keep recording their trip, IT DIDN'T START BACK UP.
//Created a stopLocationUpdates func that gets called when the user chooses either the save or discard open.
//Until either item is selected the trip continues recording.
//The trip has continued recording the entire time this menu is up, so nothing is lost, and hitting cancel just removes the menu and your trip continues uninterrupted.
/*
 locationManager.stopUpdatingLocation()
 */
        
    }
//*******************
//*******************

//Changing over to the detailed run, for us this could be the analytics page.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            detailViewController.run = run
        }
    }
//*******************
 
    
//Just make stuff disappear at the end of a drive
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
//*******************

//*******************
//Ok, looks like this is controlling the timer update, another example of how we can do the timer.
    func eachSecond(_ timer: Timer) {
        seconds += 1
print(seconds)
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(seconds))
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: Double(s))
        let minutesQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: Double(m))
        let hoursQuantity = HKQuantity(unit: HKUnit.hour(), doubleValue: Double(h))
        timeLabel.text = "Time: "+hoursQuantity.description+" "+minutesQuantity.description+" "+secondsQuantity.description
        
        //How we can display our total distance
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        //Displaying current speed
        paceLabel.text = "Current speed: "+String((instantPace*3.6*10).rounded()/10)+" km/h"//"Pace: "+String((distance/seconds*3.6*10).rounded()/10)+" km/h"
        
        //Displaying the accel
//        climbLabel.text = "Accel: "+String((accel*10).rounded()/10)+" m/s^2"
        
//        climbLabel.text = "Total climb: "+String((vertClimb*10).rounded()/10)+" m"
//        descentLabel.text = "Total descent: "+String((vertDescent*10).rounded()/10)+" m"
        
    }
    
    //Just conerting from seconds to hours, minutes, seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
//*******************
    
//Starting to update the location
    func startLocationUpdates() {
    //started variable flipped to 1 to start drawing the polyline. With this technique there is a wee bit of a delay but I'm going to assume that is safe as the user probably won't start a trip while driving.
        started = 1
    //*******************
        locationManager.startUpdatingLocation()
        print("start location update")
    }
//*******************
    
    
//Some fucky testing going on here
    func stopLocationUpdates() {
    //Flipping it back to 0 when the stop is pressed AND CONFIRMED.
        started = 0
    //*******************
        locationManager.stopUpdatingLocation()
        print("stop location update")
    }
    
    
    
    
 
//*******************
//Location Manager
//Controlling the update freq of our location and grabbing current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            
            let howRecent = location.timestamp.timeIntervalSinceNow
            print ("**********")
            print (howRecent)
            print ("**********")
            
            //I have not idea what time interval this is, if it even is a time interval
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                
                //This goes through a creates our
                if self.locations.count > 0 {
                    distance += location.distance(from: self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
  
                    //Recording the accel
                    accel = (location.distance(from: self.locations.last!)/(location.timestamp.timeIntervalSince(self.locations.last!.timestamp)) - instantPace) / ((location.timestamp.timeIntervalSince(self.locations.last!.timestamp)))
                    
                    //Recording current speed
                    instantPace = location.distance(from: self.locations.last!)/(location.timestamp.timeIntervalSince(self.locations.last!.timestamp))
                    


                    //Updating the displayed region
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView2.setRegion(region, animated: true)
                    
                    
                    
//Fucky if statement for controlling the lines being drawn, only want them drawn when the stuff has started
                    if (started == 1) {
                        mapView2.add(MKPolyline(coordinates: &coords, count: coords.count))
                    }
                    
/*                    //This is just the height of the user. z vector for mapping
                    if previousAlt == -1000{
                        previousAlt = location.altitude
                    }
                    if previousAlt < location.altitude{
                        vertClimb += location.altitude-previousAlt
                    }
                    if previousAlt > location.altitude{
                        vertDescent += previousAlt-location.altitude
                    }
                    previousAlt=location.altitude
*/
                }
                
                //save location
                self.locations.append(location)
            }
        }
        
    }
//*******************
//*******************

//Keeps the map centered, will need this for the dashboard map
    func centerMapOnLocation(location: CLLocation, distance: CLLocationDistance) {
        let regionRadius = distance
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView2.setRegion(coordinateRegion, animated: true)
    }
//*******************
    
//*******************
//*******************
//*******************
//This is how we are going to be saving our drives, just needs to be translated into a model layout instead of CoreData.
//Will be screwing with this at a later date.
    func saveRun() {
        // 1
        let savedRun = NSEntityDescription.insertNewObject(forEntityName: "Run",
                                                           into: managedObjectContext!) as! Run
        savedRun.distance = NSNumber(value: distance)
        savedRun.duration = (NSNumber(value: seconds))
        savedRun.timestamp = NSDate() as Date
//        savedRun.climb = NSNumber(value: vertClimb)
//        savedRun.descent = NSNumber(value: vertDescent)
        
        // 2
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObject(forEntityName: "Location",
                                                                    into: managedObjectContext!) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = NSNumber(value: location.coordinate.latitude)
            savedLocation.longitude = NSNumber(value: location.coordinate.longitude)
            savedLocations.append(savedLocation)
        }
        
        savedRun.locations = NSOrderedSet(array: savedLocations)
        run = savedRun

        do{
            try managedObjectContext!.save()
        }catch{
            print("Could not save the run!")
        }
    }
//*******************
//*******************
//*******************
   
    
//Rendering the live feed line on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
//*******************

    
//This is an AudioToolbox item, not going to carry into our project.
/*
    func playSuccessSound() {
        let soundURL = Bundle.main.url(forResource: "success", withExtension: "wav")
        var soundID : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as! CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
        
        //also vibrate
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
    }
 */
//***********************
    
}

// MARK: UIActionSheetDelegate
//Action sheet stuff, I think Santiago understands this way better than I do.
extension NewRunViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        //save
        if buttonIndex == 1 {
            stopLocationUpdates()
            saveRun()
            performSegue(withIdentifier: DetailSegueName, sender: nil)
        }
            //discard
        else if buttonIndex == 2 {
            stopLocationUpdates()
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
//*******************
