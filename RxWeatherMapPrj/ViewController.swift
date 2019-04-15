//
//  ViewController.swift
//  RxWeatherMapPrj
//
//  Created by Euijoon Jung on 12/04/2019.
//  Copyright © 2019 Euijoon Jung. All rights reserved.
//

import UIKit
import SwiftEventBus
import RxSwift
import KTGisSDk
import Alamofire
import AlamofireObjectMapper
import CoreLocation
import GoogleMaps


class ViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var airStatus: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var weatherMotherView: UIView!
    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    let disposeBag : DisposeBag = DisposeBag()
    var weatherViewModel : WeatherViewModel!
    var addressViewModel : AddressViewModel!
    var airViewModel : AirViewModel!
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel = WeatherViewModel()
        addressViewModel = AddressViewModel()
        airViewModel = AirViewModel()
        setUpLocationManager()
        setUpMapView()
        setUpTemperatureBinding()
        setUpSkyStatusBinding()
        setUpCoordinateBinding()
        setUpAddressBinding()
        setUpAirBinding()
        self.view.bringSubview(toFront: weatherMotherView)
        
    }
    func setUpAirBinding(){
        airViewModel.airValue.asObservable().subscribe(onNext: { (air) in
            print("===============뷰컨트롤러")
            print(air)
            guard let pm10 = air.pm10Value , let pm25 = air.pm25Value else {return}
            self.airStatus.text = "pm10 : \(pm10) pm25 : \(pm25)"
            
        })
//        airViewModel.airValue.asObservable().subscribe(onNext: { (air) in
//            guard let list = air.list else {return}
//
//        })
    }
    
    func setUpAddressBinding(){
        //viewModel -> view notification
        addressViewModel.addressValue.asObservable().subscribe(onNext: { (location) in
            guard let fullAddress = location.getFullAddress() else {return}
            self.addressLabel.text = fullAddress
        })
    }
    func setUpTemperatureBinding(){
        
        let weatherValueObservable = weatherViewModel.weatherValue.filter{$0.list != nil}.filter{$0.list!.count>0}
        let tempChangeValueObservable = weatherViewModel.tempValueChange.asObservable()
//
//        let disposable = Observable.zip(weatherValueObservable, tempChangeValueObservable) { (weather, temp) -> Void in
//            guard let list = weather.list else {return}
//            guard let main = list[0].main else {return}
//            self.temperatureLabel.text = "\(main.temp!)"
//
//
//
//            if temp == WeatherDiff.down { self.temperatureLabel.textColor = UIColor.blue}
//            else if temp == WeatherDiff.up {self.temperatureLabel.textColor = UIColor.red}
//            else if temp == WeatherDiff.normal {self.temperatureLabel.textColor = UIColor.black}
//
//        }
//
//        weatherViewModel.weatherValue.asObservable().pairwise().subscribe(onNext: { (weather1, weather2) in
//            guard let list1 = weather1.list , let list2 = weather2.list else {return}
//            guard let main1 = list1[0].main, let main2 = list2[0].main else {return}
//            self.temperatureLabel.text = "\(main2.temp!)"
//            if main2.temp! - main1.temp! > 0 { self.temperatureLabel.textColor = UIColor.red}
//            else if main2.temp! - main1.temp! == 0 {self.temperatureLabel.textColor = UIColor.black}
//            else {self.temperatureLabel.textColor = UIColor.blue}
//
//
//
//        })

        weatherViewModel.tempValueChange.asObservable().subscribe(onNext: { (diff) in
            print(#function + "\(diff)")
            switch diff {
            case WeatherDiff.down : self.temperatureLabel.textColor = UIColor.blue
                break
            case WeatherDiff.normal : self.temperatureLabel.textColor = UIColor.black
                break
            case WeatherDiff.up : self.temperatureLabel.textColor = UIColor.red
                
            }
            
        })
        
        weatherViewModel.weatherValue.asObservable().filter{ $0.list != nil }.filter{$0.list!.count > 0}
        .subscribe(onNext: { (weather) in
            guard let list = weather.list else {return}
            guard let main = list[0].main else {return}
            self.temperatureLabel.text = "\(main.temp!)"
        })
        
    }
    func setUpSkyStatusBinding(){
        weatherViewModel.weatherValue.asObservable().filter{ $0.list != nil }.filter{$0.list!.count > 0}
            .subscribe(onNext: { (weather) in
                guard let list = weather.list else {return}
                guard let weather_ = list[0].weather else {return}
                
                self.skyLabel.text = "\(weather_[0].skyStatusDescription!)"
                
            })
    }
    func setUpCoordinateBinding(){
        weatherViewModel.weatherValue.asObservable().filter{ $0.list != nil }.filter{$0.list!.count > 0}
            .subscribe(onNext: { (weather) in
                guard let city = weather.city else {return}
                guard let coord = city.coord else {return}
                guard let lat = coord.lat , let lng = coord.lon else {return}
                self.coordinateLabel.text = "\(lat) \(lng)"
            })
    }
    
    
    func setUpMapView(){
        mapView.delegate = self
        mapView.settings.compassButton = true
        //mapView.settings.myLocationButton = true
    }
    
    
    func changeCurrentMarker(location : CLLocation){
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        mapView.animate(to : GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0))
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.isDraggable = true
        marker.map = mapView
        
    }
    
    func setUpLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            
            mapView.clear()
            locationManager.stopUpdatingLocation()
            let coordinate = location.coordinate
            changeCurrentMarker(location: location)
            
        }
    }
    func changeCamera(location : CLLocationCoordinate2D){
        mapView.animate(to: GMSCameraPosition(latitude: location.latitude, longitude: location.longitude, zoom: 15.0))
    }
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        //print(#function)
        let location = marker.position
        changeCamera(location: marker.position)
        
        // view -> (eventbus) -> viewmodel
        EventBus.instance.post(event: LocationChangedEvent.init(location: marker.position))
       
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        //print(#function)
    }
    
    

}
