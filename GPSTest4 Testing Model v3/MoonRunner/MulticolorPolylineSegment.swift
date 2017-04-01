//File for drawing the lines.
//I've been tinkering with the math on this page.

import Foundation
import UIKit
import MapKit

class MulticolorPolylineSegment: MKPolyline {
    var color: UIColor?

//This is going to be used for some of the analytics stuff
//Will need to be migrated to a model
    
    //Class for storing all the speed measurements
    class func colorSegments(forLocations locations: [Location]) -> [MulticolorPolylineSegment] {
        var colorSegments = [MulticolorPolylineSegment]()

        // RGB for Red (slowest)
        let red   = (r: 1.0, g: 20.0 / 255.0, b: 44.0 / 255.0)
        
        // RGB for Yellow (middle)
        let yellow = (r: 1.0, g: 215.0 / 255.0, b: 0.0)
        
        // RGB for Green (fastest)
        let green  = (r: 0.0, g: 146.0 / 255.0, b: 78.0 / 255.0)
        
//        var speeds = [Double]()
//        var accels = [Double]() //Variable for accel, (delta V)/(delta time). (distance/time)/time.
        let maxAccel = 4.6
            
            for i in 1..<locations.count {
                //Grabbing a slice of travel
                let l1 = locations[i-1]
                let l2 = locations[i]
                
                var coords = [CLLocationCoordinate2D]()
                coords.append(CLLocationCoordinate2D(latitude: l1.latitude.doubleValue, longitude: l1.longitude.doubleValue))
                coords.append(CLLocationCoordinate2D(latitude: l2.latitude.doubleValue, longitude: l2.longitude.doubleValue))
                
                
                //Getting the gps readings for each travel point
                let cl1 = CLLocation(latitude: l1.latitude.doubleValue, longitude: l1.longitude.doubleValue)
                let cl2 = CLLocation(latitude: l2.latitude.doubleValue, longitude: l2.longitude.doubleValue)
                
                //Finding the distance between the two points
                let distance = cl2.distance(from: cl1)
                //Finding the time taken to travel between the two points
                let time = l2.timestamp.timeIntervalSince(l1.timestamp)
                //Distance/time to get the speed
                let speed = distance/time
                let accel = speed/time - speed
                
                let ratio = accel/maxAccel
                var color = UIColor.black
                
                if (abs(accel) > (maxAccel/2)) || (speed > 120) { // Between Red & Yellow
                    //                let ratio = (speed - (meanSpeed-(meanSpeed*0.1))) / (meanSpeed - minSpeed)
                    let r = CGFloat(red.r + ratio * (yellow.r - red.r))
                    let g = CGFloat(red.g + ratio * (yellow.g - red.g))
                    let b = CGFloat(red.b + ratio * (yellow.b - red.b))
                    color = UIColor(red: r, green: g, blue: b, alpha: 1)
                }
                else { // Between Yellow & Green
                    //                var ratio = ((speed) - meanSpeed) / (maxSpeed - meanSpeed)
                    //                if ratio > 1{
                    //                    ratio=1
                    //                }
                    let r = CGFloat(yellow.r + ratio * (green.r - yellow.r))
                    let g = CGFloat(yellow.g + ratio * (green.g - yellow.g))
                    let b = CGFloat(yellow.b + ratio * (green.b - yellow.b))
                    color = UIColor(red: r, green: g, blue: b, alpha: 1)
                }
                
                //Defining each segment of coloured line
                //We will need to make sure our measurement of segment stays consistent throughout the app
                let segment = MulticolorPolylineSegment(coordinates: &coords, count: coords.count)
                segment.color = color
                colorSegments.append(segment)
        }
        
        return colorSegments
    }
}
