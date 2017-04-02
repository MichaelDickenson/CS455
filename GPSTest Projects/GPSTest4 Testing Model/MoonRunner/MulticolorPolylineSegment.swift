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
    private class func allSpeeds(forLocations locations: [Location]) ->
            (speeds: [Double], accels: [Double]) {
//          (speeds: [Double], minSpeed: Double, maxSpeed: Double, maxAccel: Double, accels: [Double]) {
            // Make Array of all speeds. Find slowest and fastest
            var speeds = [Double]()
//           var minSpeed = DBL_MAX
//           var maxSpeed = 0.0
            
//Michael created variables
    //Going to use the outlet for climb to show accel.
 //       let maxAccel = 4.6 // Using a mazda3 MPS. 0-100 kph in 6.1s. the 0-100 converts to 27.8m/s. We then get 27.8/6.1 for an average acceleration of 4.6m/s^2.
        var accels = [Double]() //Variable for accel, (delta V)/(delta time). (distance/time)/time.
        //Going to use the outlet for descent for consumption
//        var carConsumptiion = 24.0 //Cars documented consumption
//        var trueConsumption = 0.0 //Cars current consumption
            
            
            for i in 1..<locations.count {
                //Grabbing a slice of travel
                let l1 = locations[i-1]
                let l2 = locations[i]
                
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
                
                //Min and max speed, going to try to use this for accel and other calcs.
                //We'll be keeping it, at least for now
//                minSpeed = min(minSpeed, speed)
//                maxSpeed = max(maxSpeed, speed)
                
                speeds.append(speed)
                accels.append(accel)
            }
            
//            return (speeds, minSpeed, maxSpeed, maxAccel, accels)
              return (speeds, accels)
    }
    
 
//Class for the colour segments
//Sets the colours colour
//Sets the ranges for when a colour will be displayed
    //Will be updating the ranges to use effeciency factor once that is being calculated.
//IN PROGRESS
    class func colorSegments(forLocations locations: [Location]) -> [MulticolorPolylineSegment] {
        var colorSegments = [MulticolorPolylineSegment]()
        
        // RGB for Red (slowest)
        let red   = (r: 1.0, g: 20.0 / 255.0, b: 44.0 / 255.0)
        
        // RGB for Yellow (middle)
        let yellow = (r: 1.0, g: 215.0 / 255.0, b: 0.0)
        
        // RGB for Green (fastest)
        let green  = (r: 0.0, g: 146.0 / 255.0, b: 78.0 / 255.0)
        
        
//Michael created variables
        //Going to use the outlet for climb to show accel.
        let maxAccel = 4.6 // Using a mazda3 MPS. 0-100 kph in 6.1s. the 0-100 converts to 27.8m/s. We then get 27.8/6.1 for an average acceleration of 4.6m/s^2.
        
        
        //Not really sure what is happening in these following lines
        //Looks like we're creating variables to work with
//        let (speeds, minSpeed, maxSpeed, maxAccel, accels) = allSpeeds(forLocations: locations)
        let (speeds, accels) = allSpeeds(forLocations: locations)
        //This is totaling all the speeds to give us the mean speed on the run finished screen
    
//Total speeds calc
//Remove this in favour of accel
//        var totalSpeeds = 0.0
//        for speed in speeds{
//            totalSpeeds+=speed
//        }
//        let meanSpeed = totalSpeeds/Double(speeds.count)
//*****************************
        
        //Walking through each location item
        for i in 1..<locations.count {
            //item and the previous item, starts at i=1
            let l1 = locations[i-1]
            let l2 = locations[i]
            
            //Setting up the coords variable to be a CLloc2d object array, possibly.
            var coords = [CLLocationCoordinate2D]()
            
            //Setting the coords variables for the two location items we are working with
            coords.append(CLLocationCoordinate2D(latitude: l1.latitude.doubleValue, longitude: l1.longitude.doubleValue))
            coords.append(CLLocationCoordinate2D(latitude: l2.latitude.doubleValue, longitude: l2.longitude.doubleValue))
            
            //Finding the speed of the current segment we are working with.
            //speeds is calculated up in the allSpeeds class object
            
            let speed = speeds[i-1]
            let accel = accels[i-1]
            let ratio = accel/maxAccel
            var color = UIColor.black
            
            
            //This is us setting the colour range.
            //Currently be setting by the speed range in comparison of the mean speed.
            //We will be doing with by ranging off of effeciency ratings, just need to find where to make that measurement
//Using the abs of accel so we can figure out if they are also breaking to hard
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
