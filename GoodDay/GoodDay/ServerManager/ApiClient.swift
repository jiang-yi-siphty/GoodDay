//
//  ApiClient.swift
//  GoodDay
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Thred. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

class ApiClient: ApiService {
    
    func fetchOWMWeather(_ config: ApiConfig) -> Observable<RequestStatus> {
        let url = config.getFullUrl()
        return Observable<RequestStatus>.create { observable -> Disposable in
            self.networkRequestByNSURLConnection(url, completionHandler: { (json, error) in
                guard let json = json else {
                    if let error = error {
                        observable.onNext(RequestStatus.fail(RequestError("API Response failed: \(error.errorDescription ?? "Error doesn't have message")")))
                    } else {
                        observable.onNext(RequestStatus.fail(RequestError("No Api Response, No Error message.")))
                    }
                    observable.onCompleted()
                    return
                }
                if let apiResponse = Mapper<ApiResponse>().map(JSON: json) {
                    observable.onNext(RequestStatus.success(apiResponse))
                    observable.onCompleted()
                } else {
                    observable.onNext(RequestStatus.fail(RequestError("Parse Weather information failed.")))
                    observable.onCompleted()
                }
            })
            return Disposables.create()
            }.share()
    }
    
    func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(url).responseJSON(queue: DispatchQueue.global(), options: .allowFragments) { response in
            guard let json = response.result.value as? [String: Any] else {
                print("Error: \(String(describing: response.result.error))")
                completionHandler(nil, RequestError((response.result.error?.localizedDescription)!))
                return
            }
            completionHandler(json, nil)
        }
    }
    
}

// Other Network request methods
// Conform to ApiService protocol. For new class inherit from ApiClient class,
// you can overwrite this function and use any other HTTP networking libraries.
// Like in Unit test, I created MockApiClient which request network by load local JSON file.
extension ApiClient {
    
    func networkRequestByAlamoFire(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(url).responseJSON(queue: DispatchQueue.global(), options: .allowFragments) { response in
            guard let json = response.result.value as? [String: Any] else {
                print("Error: \(String(describing: response.result.error))")
                completionHandler(nil, RequestError((response.result.error?.localizedDescription)!))
                return
            }
            completionHandler(json, nil)
        }
    }
    
    func networkRequestByNSURLSession(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, RequestError(error.localizedDescription))
            } else if let data = data {
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completionHandler(json, nil)
                    } else {
                        completionHandler(nil, RequestError("JSON decode failed!!!"))
                    }
                } catch let error {
                    completionHandler(nil, RequestError(error.localizedDescription))
                }
            }
        }
        task.resume()
    }
    
    func networkRequestByNSURLConnection(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let queue: OperationQueue = OperationQueue()
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue) { (response, data, error) in
            if let error = error {
                completionHandler(nil, RequestError(error.localizedDescription))
            } else if let data = data {
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completionHandler(json, nil)
                    } else {
                        completionHandler(nil, RequestError("JSON decode failed!!!"))
                    }
                } catch let error {
                    completionHandler(nil, RequestError(error.localizedDescription))
                }
            }
            
        }
    }
}
