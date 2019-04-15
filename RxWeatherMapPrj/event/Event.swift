//
//  Event.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation

struct EventType {
    static let locationChanged = 1000
}

protocol Event{
    var type: Int{ get }
}
