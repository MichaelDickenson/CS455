//
//  VehicleProfile.swift
//  VehiclesAPI
//
//  Created by Santiago Félix Cárdenas on 2017-02-20.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import os.log

class VehicleProfile: NSObject, NSCoding {
    
    // MARK: Properties
    
    var photo: UIImage?
    var name: String? = ""
    var make: String = ""
    var model: String = ""
    var year: String = ""
    var trim: String = ""
    var type: String = ""
    var id: String = ""
    var maxAcceleration: Double = 0.0
    var efficiency: Double = 0.0
    var cylinder: String = ""
    var size: String = ""
    var horsepower: String = ""
    var torque: String = ""
    var gas: String = ""
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("vehicles")
    
    // MARK: Types
    
    struct PropertyKey {
        static let photo = "name"
        static let name = "name"
        static let make = "make"
        static let model = "model"
        static let year = "year"
        static let trim = "trim"
        static let type = "type"
        static let id = "id"
        static let maxAcceleration = "maxAcceleration"
        static let efficiency = "efficiency"
        static let cylinder = "cylinder"
        static let size = "size"
        static let horsepower = "horsepower"
        static let torque = "torque"
        static let gas = "gas"
    }
    
    //MARK: Initialization
    
    init?(photo: UIImage, name: String, make: String, model: String, year: String, trim: String, type: String, id: String, maxAcceleration: Double, efficiency: Double, cylinder: String, size: String, horsepower: String, torque: String, gas: String) {

        // Initialize stored properties.
        self.photo = photo
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.trim = trim
        self.type = type
        self.id = id
        self.maxAcceleration = maxAcceleration
        self.efficiency = efficiency
        self.cylinder = cylinder
        self.size = size
        self.horsepower = horsepower
        self.torque = torque
        self.gas = gas
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(make, forKey: PropertyKey.make)
        aCoder.encode(model, forKey: PropertyKey.model)
        aCoder.encode(year, forKey: PropertyKey.year)
        aCoder.encode(trim, forKey: PropertyKey.trim)
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(maxAcceleration, forKey: PropertyKey.maxAcceleration)
        aCoder.encode(efficiency, forKey: PropertyKey.efficiency)
        aCoder.encode(cylinder, forKey: PropertyKey.cylinder)
        aCoder.encode(size, forKey: PropertyKey.size)
        aCoder.encode(horsepower, forKey: PropertyKey.horsepower)
        aCoder.encode(torque, forKey: PropertyKey.torque)
        aCoder.encode(gas, forKey: PropertyKey.gas)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let make = aDecoder.decodeObject(forKey: PropertyKey.make) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let model = aDecoder.decodeObject(forKey: PropertyKey.model) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let year = aDecoder.decodeObject(forKey: PropertyKey.year) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let trim = aDecoder.decodeObject(forKey: PropertyKey.trim) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let maxAcceleration = aDecoder.decodeObject(forKey: PropertyKey.maxAcceleration) as? Double else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let efficiency = aDecoder.decodeObject(forKey: PropertyKey.efficiency) as? Double else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let cylinder = aDecoder.decodeObject(forKey: PropertyKey.cylinder) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let size = aDecoder.decodeObject(forKey: PropertyKey.size) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let horsepower = aDecoder.decodeObject(forKey: PropertyKey.horsepower) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let torque = aDecoder.decodeObject(forKey: PropertyKey.torque) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let gas = aDecoder.decodeObject(forKey: PropertyKey.gas) as? String else {
            os_log("Unable to decode the name for a Vehicle object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(photo: photo!, name: name, make: make, model: model, year: year, trim: trim, type: type, id: id, maxAcceleration: maxAcceleration, efficiency: efficiency, cylinder: cylinder, size: size, horsepower: horsepower, torque: torque, gas: gas)
        
    }
    
    func saveVehicle() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: VehicleProfile.ArchiveURL.path)
        print(VehicleProfile.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Vehicle successfully saved. Did it really save?????", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save vehicle...", log: OSLog.default, type: .error)
        }
    }
    
    func loadVehicle() -> VehicleProfile?  {
        print("I am printing this")
        print(NSKeyedUnarchiver.unarchiveObject(withFile: VehicleProfile.ArchiveURL.path) as? VehicleProfile! as Any)
        return NSKeyedUnarchiver.unarchiveObject(withFile: VehicleProfile.ArchiveURL.path) as? VehicleProfile
    }
}

