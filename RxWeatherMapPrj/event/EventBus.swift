//
//  EventBus.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import RxSwift

final class EventBus{
    static let instance : EventBus = {
        return EventBus()
    }()
    private init(){}
    
    var busDic = [Int : PublishSubject<Event>]()
    
    func post(event : Event){
        if let bus = busDic[event.type]{
            //print("이벤트 발생!!!")
            bus.onNext(event)
        }
    }
    
    func observe(eventType : Int) -> Observable<Event> {
        //print("이벤트 옵저버")
        if let bus = busDic[eventType]{
            return bus.asObservable()
        }
        let newBus = PublishSubject<Event>()
        busDic[eventType] = newBus
        return newBus.asObservable()
        
    }
}
