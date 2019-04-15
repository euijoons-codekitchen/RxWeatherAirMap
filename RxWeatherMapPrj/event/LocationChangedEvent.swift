//
//  LocationChangedEvent.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import CoreLocation
class LocationChangedEvent : Event {
    let location : CLLocationCoordinate2D
    
    var type : Int{
        return EventType.locationChanged
    }
    init(location : CLLocationCoordinate2D){
        self.location = location
    }
}
