//
//  AirHelper.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AirManager{
    static func getAirStatus(_ siDo_ : String?, completion : @escaping(AirResponse?)->Void){
        guard let siDo = siDo_ else {return}
        print(#function + "siDo : " +  siDo)
        
        guard let newStr = String(utf8String: siDo.cString(using: .utf8)!) else {return}
        print(newStr)
        let headers : [String:String] = [
            "Content-Type" : "application/json"]
     
        var airUrl = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?ServiceKey=ldCSA2%2Bs7gn1hQXvoP8F6lU6ZumPIRKTegbHA26mGU%2FojGMcEHZgmIzaOB6qQ%2BRoo9KENOm4%2BWrxKzaFPB79%2Bw%3D%3D&numOfRows=10&pageNo=1&searchCondition=HOUR&_returnType=json&sidoName="
        var korean = siDo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        airUrl = airUrl + korean!
        
        Alamofire.request(airUrl, method: .get, encoding: URLEncoding.queryString,headers: headers).responseObject { (response : DataResponse<AirResponse>) in
            if response.error != nil {
                print(#function + "\(response.error)")
            }
            if response.result.isSuccess{
                //print(#function + " air result : \(response.value)")
                completion(response.value)
            }else {
                print("\(response.result)")
                print("\(response.error)")
                print("\(response.value)")
                print("\(response.request)")
                print(#function + "air request failed")
            }
            
            
        }
        
        
        
        
    }
    
}


