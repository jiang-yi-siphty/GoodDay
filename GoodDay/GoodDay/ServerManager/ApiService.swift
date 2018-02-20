//
//  ApiService.swift
//  GoodDay
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Thred. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


enum RequestStatus {
    case success(ApiResponse)
    case fail(RequestError)
}

struct RequestError : LocalizedError {
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    private var mMsg : String
    
    init(_ description: String) {
        mMsg = description
    }
}

enum  ApiConfig {
    case weather(Int)
    //We can add other APIs by add more cases
    //e.g.
    //case aircrafts(CLLocation, Int)
    //    fileprivate static let AEBaseUrl = "http://public-api.adsbexchange.com"
    
    //OWM: OpenWeatherMap
    fileprivate static let owmBaseUrl = "https://api.openweathermap.org/"
    fileprivate static let owmApiVersion = "2.5"
    fileprivate static let owmApiKey = "efa9fc0f74ac42e64b50e4510faa713b"
    
    
    var urlPath: String {
        switch self {
        case .weather(let cityCode):
            return "/data/\(ApiConfig.owmApiVersion)/weather?id=\(cityCode)&units=metric&APPID=\(ApiConfig.owmApiKey)"
        //We can add other APIs' url path cases
        //e.g.
        //case .aircrafts(let location, let radius):
        //    return "/VirtualRadar/AircraftList.json?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&fDstL=0&fDstU=\(radius)"
        }
    }
    
    func getFullUrl() -> URL {
        var baseUrl: String!
        switch self {
        case .weather(_):
            baseUrl = ApiConfig.owmBaseUrl
        }
        
        if let url = URL(string: baseUrl + self.urlPath)  {
            return url
        } else {
            return URL(string: baseUrl)!
        }
    }
}

protocol ApiService {
    func fetchOWMWeather(_ config: ApiConfig) -> Observable<RequestStatus>
    func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void))
    func tcpConnect()
}
