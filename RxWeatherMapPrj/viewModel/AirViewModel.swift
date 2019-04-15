//
//  AirViewModel.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 14/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import RxSwift
import KTGisSDk

class AirViewModel {
    var airValue : PublishSubject<Air>!
    init(){
        airValue = PublishSubject<Air>()
        startObserving()
    }
    func startObserving(){
        EventBus.instance.observe(eventType: EventType.locationChanged)
            .subscribe(onNext: { (event) in
                let locationEvent = event as! LocationChangedEvent
                let location = locationEvent.location
                
                KTGisGeocodeManager.getAddressFromCoordinateGET(lat: location.latitude, lng: location.longitude, completion: { (residential_) in
                    guard let residential = residential_ else {return}
                    guard let refinedLocation = residential.location() else {return}
                    guard let siDo = refinedLocation.getSido(), let siGunGU = refinedLocation.getSiGunGu() else {return}
                    guard let airSiDo = AddressFormatter.trimSido(siDo) else {return}
                    
                    AirManager.getAirStatus(airSiDo, completion: { [weak self](air_) in
                        guard let air = air_ else {return}
                        guard let list = air.list else {return}
                        guard let strongSelf = self else {return}
                        for index in list{
                            //print("index : \(index), sigungu : \(siGunGU)")
                            if index.cityName! == siGunGU{
                                print("============================찾음")
                                var airResponse = Air()
                                airResponse.cityName = siGunGU
                                airResponse.sidoName = refinedLocation.getSido()
                                airResponse.pm10Value = index.pm10Value
                                airResponse.pm25Value = index.pm25Value
                                strongSelf.airValue.onNext(airResponse)
                                break;
                            }
                        }
                        
                        
                    })
                    
                }, onError: {error_  in
                })
            })
        
    }
}
