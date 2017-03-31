//
//  VehicleProfile.swift
//  VehiclesAPI
//
//  Created by Santiago Félix Cárdenas on 2017-02-20.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit

struct VehicleProfile {
    
    //MARK: Properties
    var photo: UIImage?
    var name: String? = ""
    var make: String = ""
    var model: String = ""
    var year: String = ""
    var trim: String = ""
    var type: String = ""
    var id: String = ""
    
    //MARK: Initialization
    
    init?(photo: UIImage, name: String, make: String, model: String, year: String, trim: String, type: String, id: String) {
        
        // Initialize stored properties.
        self.photo = photo
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.trim = trim
        self.type = type
        self.id = id
    }
}

