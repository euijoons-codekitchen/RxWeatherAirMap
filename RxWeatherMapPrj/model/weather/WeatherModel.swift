//
//  WeatherModel.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import ObjectMapper



struct Weather : Mappable{
    var cod: String?
    var message: Double?
    var cnt: Int?
    var list: [list]?
    var city: city?
     init?(map: Map) {
        
    }
    init(){}
    
    mutating func mapping(map: Map) {
        self.list <- map["list"]
        self.city <- map["city"]
        self.cod <- map["cod"]
        self.message <- map["message"]
        self.cnt <- map["cnt"]
    }
    
}


struct city :Mappable{
    var id: Int?
    var name: String?
    var coord: coord?
    var country: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.coord <- map["coord"]
        self.country <- map["country"]
    }
    

}

struct coord : Mappable{
    
    var lat, lon: Double?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.lat <- map["lat"]
        self.lon <- map["lon"]
    }
    
}

struct list : Mappable{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.dt <- map["dt"]
        self.main <- map["main"]
        self.weather <- map["weather"]
        //self.wind <- map["wind"]
        self.dtTxt <- map["dt_txt"]
    }
    
    var dt: Int?
    var main: main?
    var weather: [WeatherElement]?
    //var clouds: clouds?
    //var wind: Wind?
    //var sys: Sys?
    var dtTxt: String?
    
   
}

struct main : Mappable{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.temp <- map["temp"]
        self.tempMax <- map["temp_max"]
        self.tempKf <- map["temp_kf"]
        self.pressure <- map["pressure"]
        self.tempMin <- map["temp_min"]
        self.seaLevel <- map["sea_level"]
        self.grndLevel <- map["grnd_level"]
        self.humidity <- map["humidity"]
        
    }
    
    var temp, tempMin, tempMax, pressure: Double?
    var seaLevel, grndLevel: Double?
    var humidity: Int?
    var tempKf: Double?
    
    
}


struct WeatherElement :Mappable{
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.skyStatus <- map["main"]
        self.skyStatusDescription <- map["description"]
        self.icon <- map["icon"]
    }
    
    var id: Int?
    var skyStatus: String?
    var skyStatusDescription, icon: String?
    
}

