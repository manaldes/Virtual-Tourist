//
//  PinExtention.swift
//  virtualTourist
//
//  Created by Manal  harbi on 04/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import UIKit
import MapKit


extension Pin {
    
    var coordinate: CLLocationCoordinate2D {
        
        set {
            latitude = newValue.latitude
            longtude = newValue.longitude
            
        }
        
        get {
            return CLLocationCoordinate2D.init(latitude: latitude, longitude: longtude)
            
        }
    }
    
    
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }

    func compare (to coordinate:CLLocationCoordinate2D) -> Bool {
        return ( latitude == coordinate.latitude && longtude == coordinate.longitude )
    }



}
