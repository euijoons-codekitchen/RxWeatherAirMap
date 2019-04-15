//
//  AddressFormatter.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 14/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
var SiDoDic : [String : String] = [
    "서울특별시" : "서울",
    "경기도" : "경기",
    "인천광역시" : "인천",
    "부산광역시" : "부산",
    "울산광역시" : "울산",
    "대전광역시" : "대전",
    "광주광역시" : "광주",
    "강원도" : "강원",
    "전라남도" : "전남",
    "전라북도" : "전북",
    "경상남도" : "경남",
    "경상북도" : "경북",
    "대구광역시" : "대구",
    "충청남도" : "충남",
    "충청북도" : "충북"
]

class AddressFormatter {
    static func trimSido(_ siDo_ : String?) -> String?{
        guard let siDo = siDo_ else {return "notFound"}
        return SiDoDic[siDo]
        
    }
    static func trimSiGunGu(_ siGunGu : String) -> String{
        var result = ""
        return result
    }
}
