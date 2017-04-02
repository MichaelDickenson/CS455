//Displays the Run Details screen.
//This file is all for display the map view.
//Contains time, distance, average speed.
//Draws the lines on the map.

//I have currently commented out the climb and descent items just cause we aren't going to bother displaying them
//If you try to save a run with them disabled the app crashes, to get it to stop crashing just uncomment the IBOutlets
//and the .text items under the Displayed climb item.
//IBOutlets are currently uncommented, going to deal with them some other time as I feel it will require some work in the CoreData and UI to be able to leave them commented without crashing stuff.

//I didn't use MARK because I forgot it existed until I was writing these comments. Will change in the near future.

import UIKit
import MapKit
import HealthKit

class DetailViewController: UIViewController,MKMapViewDelegate {
    var run: Run!
    var mapOverlay: MKTileOverlay!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
// Again commenting out the climbing stuff, we aren't going to do enough with it to make it worth displaying
//I'm leaving these IBOutlets uncommented as the app crashes when they are commented, commenting everything that updates them
    @IBOutlet weak var climbLabel: UILabel!
    @IBOutlet weak var descentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: run.timestamp)

//*******************
//*******************
//This is the method for tracking time using health kit, theres a func that is used for converting seconds a little further down as well. called secondsToHoursMinutesSeconds
//Display For Time
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(run.duration.doubleValue))
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: Double(s))
        let minutesQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: Double(m))
        let hoursQuantity = HKQuantity(unit: HKUnit.hour(), doubleValue: Double(h))
        timeLabel.text = "Time: "+hoursQuantity.description+" "+minutesQuantity.description+" "+secondsQuantity.description
//*******************
//*******************
//*******************
//*******************
        
//Display for Distance
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: run.distance.doubleValue)
        distanceLabel.text = "Distance: " + distanceQuantity.description
//*******************
        
//Display for Mean Speed, we might scrap this
        paceLabel.text = "Mean speed: "+String((run.distance.doubleValue/run.duration.doubleValue*3.6*10).rounded()/10)+" km/h"
//*******************
 
//Displayd climb
//The math is already here so we can use it for our calculations
//We could also scrap it, right now I'm just commenting out the
//display text
 //       climbLabel.text = "Total climb: "+String((run.climb.doubleValue).rounded())+" m"
 //       descentLabel.text = "Total descent: "+String((run.descent.doubleValue).rounded())+" m"
//*******************
        
        loadMap()
    }
    
//Time Conversion
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
//*******************
    
//Focusing the map
//Need to tweak this to show the entire drive. Might give it a hard cap on furthest zoom out, if the user has a drive from Sask to BC we do not want to zoom out far enough to show the entire drive.
//Going to need to do some pinch zoom work on this as well, I think. Haven't been able to do it in the sim, haven't found code for it either, assuming it is missing.
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = run.locations.firstObject as! Location
        
        var minLat = initialLoc.latitude.doubleValue
        var minLng = initialLoc.longitude.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run.locations.array as! [Location]
        
        for location in locations {
            minLat = min(minLat, location.latitude.doubleValue)
            minLng = min(minLng, location.longitude.doubleValue)
            maxLat = max(maxLat, location.latitude.doubleValue)
            maxLng = max(maxLng, location.longitude.doubleValue)
        }
        
        //This should be showing the entire area driven over but it is not
        //Looks like its because of the differences in between the two deltas and trying to find a compromise.
            //If one is drastically different than the other it's not going to display the whole area we want.
            //I'm currently composating for this by changing the mult factor from 1.1 to 2, not a great fix.
            //Can lead to a really bad zoom level, will need to work on being able to zoom the map.
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                           longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*2,
                                   longitudeDelta: (maxLng - minLng)*2))
    }
//*******************

//Displaying the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
    //Tile overlay for loading
        if overlay is MKTileOverlay{
            guard let tileOverlay = overlay as? MKTileOverlay else {
                return MKOverlayRenderer()
            }
            
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
    //Drawn lines overlay, maps route
        if overlay is MulticolorPolylineSegment {
            let polyline = overlay as! MulticolorPolylineSegment
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
//*******************

//Drawing the lines on the map
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = run.locations.array as! [Location]
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude.doubleValue,
                                                 longitude: location.longitude.doubleValue))
        }
        
        return MKPolyline(coordinates: &coords, count: run.locations.count)
    }
//*******************
    
//Loading in the map
    func loadMap() {
        if run.locations.count > 0 {
            mapView.isHidden = false
            //No idea what this following line does, I guess loads in a map?
            let template = "https://api.mapbox.com/styles/v1/spitfire4466/citl7jqwe00002hmwrvffpbzt/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic3BpdGZpcmU0NDY2IiwiYSI6Im9jX0JHQUUifQ.2QarbK_LccnrvDg7FobGjA"
            
            mapOverlay = MKTileOverlay(urlTemplate: template)
            mapOverlay.canReplaceMapContent = true
            
            mapView.add(mapOverlay,level: .aboveLabels)
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: run.locations.array as! [Location])
            mapView.addOverlays(colorSegments)
        } else {
            // No locations were found!
            mapView.isHidden = true
            
            UIAlertView(title: "Error",
                        message: "Sorry, this drive has no locations saved",
                        delegate:nil,
                        cancelButtonTitle: "OK").show()
        }
    }
}
