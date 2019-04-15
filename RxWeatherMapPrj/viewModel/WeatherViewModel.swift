//
//  WeatherViewModel.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import Foundation
import RxSwift
import KTGisSDk
import RxSwiftExt
//controller와 Model 사이에 위치.
//view - viewmodel - model
//뷰는 뷰모델로 command, 뷰모델은 model로 command,
//model -> view model notification
// viewmodel -> view notification..
// viewModel에는 UIKit가 들어가면 안됨

//Event bus 의 역할은..? Event Bus 가 이벤트 발생시키면 그걸 듣는 리스너는 누가 돼야하지..?
//
/*
 Event Bus 란?
 one to many notifiation.
 observer 와 같은 개념이긴 함.
 
 */
//질문 - 뷰모델 사용예시? 뷰모델 안에 subject 넣는게 맞나..? 뷰모델의 역할이 봤던 블로그마다 다른데..
//rxswift + mvvm 일 땐 뷰모델 안에 observable을 넣던데..
//realm 글 보면 뷰모델을 cell 값 configure 할때 쓰던데.. 흠

/*
 Why EventBus?? 왜 이 플젝에서 이벤트버스??
 - 뷰모델이 하나가 아니라 여러개라면? View에서 각기 다른 ViewModel로 command 해줘야 됨.
 - 근데 이걸 이벤트 버스로 처리해버리면? -> 이벤트 커맨드는 하나지만 이 이벤트를 구독하는 뷰모델이 여러개니까 이벤트버스를 통해
 한번만 이벤트 발생시키키면 여러 뷰모델로 그 커맨드가 적용됨.
 -> 이래서 이벤트 버스를 썼음.
 */

enum WeatherDiff {
    case normal
    case up
    case down
}

class WeatherViewModel{
    
    
    //var delegate : WeatherInfoDelegate? // delegate.configure 이런식으로 delegate를 하는건..?
    //이러면 View와 ViewModel 의 커플링이 심해지지 않나..? 그러니 Subject로 커플링을 줄여보자..
    var weatherValue : PublishSubject<Weather>!
    var tempValueChange : PublishSubject<WeatherDiff>!
    //var addressValue : PublishSubject<KTGisLocation>!
    //이러면 구독만하니까 View에서 이 정보를 가지고 viewupdate 하는 코드가 바뀌더라도 상관없겠지. delegate 함수가 바껴도 상관없지.
    //커플링이 delegate보다는 확실히 줄겠지
    init(){
        weatherValue = PublishSubject<Weather>()
        tempValueChange = PublishSubject<WeatherDiff>()
        //addressValue = PublishSubject<KTGisLocation>()
        
        startWeatherObserving() // 이게 여기있어도 됨..?
        //startAddressObserving() // 이게 여기있어도 됨..?
    }
    func startWeatherObserving(){
        
        EventBus.instance.observe(eventType: EventType.locationChanged)
            
            .subscribe(onNext: { (event) in
                let locationEvent = event as! LocationChangedEvent
                let location = locationEvent.location
                //viewModel -> Model command
                WeatherNetworkManager.getWeatherData(location.latitude, location.longitude){ [weak self] weather in
                    guard let strongSelf = self else {return}
                    //Model -> ViewModel. notify
                    strongSelf.weatherCombine()
                    strongSelf.weatherValue.onNext(weather)
                    
                    //strongSelf.tempValueChange.onNext(weatherCombine())
                    
                }
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }) {
                
        }
    }
    func weatherCombine(){
        
        
        weatherValue.asObservable().pairwise().subscribe(onNext: { (weather1, weather2) in
            guard let list1 = weather1.list , let list2 = weather2.list else {return}
            guard let main1 = list1[0].main, let main2 = list2[0].main else {return}
            
//            self.temperatureLabel.text = "\(main2.temp!)"
            if main2.temp! - main1.temp! > 0 { self.tempValueChange.onNext(WeatherDiff.up)}
            else if main2.temp! - main1.temp! == 0 {self.tempValueChange.onNext(WeatherDiff.normal)}
            else {self.tempValueChange.onNext(WeatherDiff.down)}
//
        
        
//        let observable1 = weatherValue.asObservable()
//        let observable2 = weatherValue.asObservable()
//
//        let observable3 = Observable.combineLatest(observable1, observable2) { (before, after) -> WeatherDiff? in
//            guard let beforeTemp = before.list?[0].main?.temp else {return nil}
//            guard let afterTemp = after.list?[0].main?.temp else {return nil}
//
//            let diff = afterTemp - beforeTemp
//
//            print(#function + "diff : \(diff)")
//            if diff > 0 {return WeatherDiff.up}//온도 올라감}
//            else if diff == 0 { return WeatherDiff.normal}//그대로}
//            else {return WeatherDiff.down}//온도 내려감}
//
//
//            }.subscribe(onNext: { (diff) in
//                self.tempValueChange.onNext(diff!)
//            })
        })
    }
    
}

