//
//  WeatherViewModel.swift
//  GoodDay
//
//  Created by Yi JIANG on 21/2/18.
//  Copyright © 2018 Thred. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WeatherViewModel {
    
    let disposeBag = DisposeBag()
    var apiResponse = Variable<ApiResponse?>(nil)
    var main = Variable<Main?>(nil)
    var city = Variable<String>("Not found")
    var country = Variable<String>("AU")
    var description = Variable<String>("NUN")
    var system = Variable<Sys?>(nil)
    var wind = Variable<Wind?>(nil)
    var cityCode = Variable<Int>(4163971)
    var humidity = Variable<String>("0")
    var temperature = Variable<String>("0")
    var tempMin = Variable<String>("0")
    var tempMax = Variable<String>("0")
    var pressure = Variable<String>("0")
    var isIndicatorHiding = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    
    init(_ apiService: ApiService, with cityCode: Int) {
        isIndicatorHiding.value = false
        bindMainWeatherDetails()
        bindSystemCountry()
        bindWeatherDescription()
        bindCityName()
        self.cityCode.value = cityCode
        fetchWeather(apiService)
    }
    
    fileprivate func fetchWeather(_ apiService: ApiService) {
        apiService.fetchOWMWeather(ApiConfig.weather(cityCode.value)).subscribe(onNext: { status in
            self.isIndicatorHiding.value = true
            switch status {
            case .success(let apiResponse):
                self.apiResponse.value = apiResponse
                self.isAlertShowing.value = false
            case .fail(let error):
                print(error.errorDescription ?? "Faild to load weather data")
                self.isAlertShowing.value = true
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    fileprivate func bindMainWeatherDetails() {
        apiResponse.asObservable().subscribe(onNext: { apiResponse in
            if let humidity = apiResponse?.main?.humidity {
                self.humidity.value = "\(humidity)%"
            }
            if let temperature = apiResponse?.main?.temp {
                self.temperature.value = "\(temperature)℃"
            }
            if let tempMin = apiResponse?.main?.tempMin {
                self.tempMin.value = "\(tempMin)℃"
            }
            if let tempMax = apiResponse?.main?.tempMax {
                self.tempMax.value = "\(tempMax)℃"
            }
            if let pressure = apiResponse?.main?.pressure {
                self.pressure.value = "\(pressure)mmHg"
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    fileprivate func bindSystemCountry() {
        apiResponse.asObservable().subscribe(onNext: { apiResponse in
            if let country = apiResponse?.sys?.country {
                self.country.value = country
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    fileprivate func bindCityName() {
        apiResponse.asObservable().subscribe(onNext: { apiResponse in
            if let cityName = apiResponse?.name {
                self.city.value = cityName
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    fileprivate func bindWeatherDescription() {
        apiResponse.asObservable().subscribe(onNext: { apiResponse in
            if let description = apiResponse?.weather?.description {
                self.description.value = description
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
