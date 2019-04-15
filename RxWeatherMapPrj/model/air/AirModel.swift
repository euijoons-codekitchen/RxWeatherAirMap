//
//  AirModel.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import ObjectMapper

struct Air {
    var sidoName, cityName, pm10Value, pm25Value : String?
}

struct AirResponse: Mappable {
    
    var list: [CtprvnMesureLIstVo2]?
    var totalCount : Int?
    //let parm, ctprvnMesureLIstVo2: CtprvnMesureLIstVo2
    //let totalCount: Int
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.list <- map["list"]
        self.totalCount <- map["totalCount"]
    }
    
    
}

struct CtprvnMesureLIstVo2: Mappable {
    init?(map: Map) {
     
    }
    
    mutating func mapping(map: Map) {
        self.sidoName <- map["sidoName"]
        self.cityName <- map["cityName"]
        self.pm10Value <- map["pm10Value"]
        self.pm25Value <- map["pm25Value"]
    }
    var sidoName, cityName : String?
    var pm10Value, pm25Value : String?
    
}
