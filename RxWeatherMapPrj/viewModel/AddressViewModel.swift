//
//  AddressViewModel.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 14/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import RxSwift
import KTGisSDk

class AddressViewModel {
    var addressValue : PublishSubject<KTGisLocation>!
    init(){
        
        addressValue = PublishSubject<KTGisLocation>()
        startAddressObserving() // 이게 여기있어도 됨..?
    }
    
    func startAddressObserving(){
        EventBus.instance.observe(eventType: EventType.locationChanged)
            .subscribe(onNext: { (event) in
                let locationEvent = event as! LocationChangedEvent
                let location = locationEvent.location
                KTGisGeocodeManager.getAddressFromCoordinateGET(lat: location.latitude, lng: location.longitude, completion: { [weak self] response in
                    guard let strongSelf = self else {return}
                    guard let residential = response else {return}
                    guard let refiendLocation = residential.location() else {return}
                    strongSelf.addressValue.onNext(refiendLocation)
                    }, onError: { (error) in
                        
                })
            })
        
    }
    
}
