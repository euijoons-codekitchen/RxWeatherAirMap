//
//  WeatherNetworkManager.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import Alamofire

class WeatherNetworkManager{
    static func getWeatherData(_ lat : Double?, _ lng : Double?, completion : @escaping(Weather)->Void){
        let weatherURL = "https://api.openweathermap.org/data/2.5/forecast"
        guard let lat_ = lat  else {return}
        guard let lng_ = lng else {return}
        var params  = [
            "lat" : lat_,
            "lon" : lng_,
            "appid" : "00e39ac47df2cdc8171ac4101b097d1f",
            "units" : "metric",
            "cnt" : 10
            
            ] as [String : Any]
        
        print("lat : \(lat) lon  : \(lng)")
        
        Alamofire.request(weatherURL, method: .get, parameters: params).responseObject { (response : DataResponse<Weather>) in
            if response.result.isSuccess{
                guard let value = response.value else {return}
                completion(value)
            }else{
                print(#function)
                print("request failed")
            }
            
        }
        
    }
}
