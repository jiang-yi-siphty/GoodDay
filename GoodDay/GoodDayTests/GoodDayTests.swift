//
//  GoodDayTests.swift
//  GoodDayTests
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import ObjectMapper
@testable import GoodDay

class GoodDayTests: XCTestCase {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessApiServiceWithCorrectApi(){
        let apiClient = ApiClient()
        apiClient.fetchOWMWeather(.weather(4163971)).subscribe(onNext: { status in
            switch status {
            case .success(let apiResponse):
                XCTAssertEqual(apiResponse.name, "Melbourne" )
                XCTAssertEqual(apiResponse.sys?.country, "US" )
                XCTAssertEqual(apiResponse.coord?.lat, -80.61 )
                XCTAssertEqual(apiResponse.coord?.lon, 28.08 )
            //MARK: We can test more key:value to verify the decode logic is right.
            case .fail(let error):
                print(error.errorDescription ?? "Faild to load weather data")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func testDecodeApiClientSuccessByMockData(){
        let mockApiClient = MockApiClient()
        mockApiClient.jsonFileName = .successData
        MockApiClient().fetchOWMWeather(ApiConfig.weather(4163971))
            .subscribe(onNext: { status in
                switch status {
                case .success(let apiResponse):
                    XCTAssertEqual(apiResponse.main?.temp, 22.82)
                    XCTAssertEqual(apiResponse.weather?.first?.descriptionField , "clear sky")
                    XCTAssertEqual(apiResponse.clouds?.all, 1)
                //MARK: We can test more key:value to verify the decode logic is right.
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func testDecodeInvalidApiKeyByMockData(){
        let mockApiClient = MockApiClient()
        mockApiClient.jsonFileName = .invalidApiKey
        mockApiClient.fetchOWMWeather(ApiConfig.weather(4163971)).subscribe(onNext: { status in
                switch status {
                case .success(let apiResponse):
                    XCTAssertNil(apiResponse.weather)
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load error data")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
    
    func testDecodeCityNotFoundByMockData(){
        let mockApiClient = MockApiClient()
        mockApiClient.jsonFileName = .cityNotFound
        mockApiClient.fetchOWMWeather(ApiConfig.weather(0)).subscribe(onNext: { status in
            switch status {
            case .success(let apiResponse):
                XCTAssertNil(apiResponse.weather)
            case .fail(let error):
                print(error.errorDescription ?? "Faild to load error data")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
}


class MockApiClient: ApiClient {
    
    enum JsonFileName: String {
        case successData = "MockSuccessData"
        case invalidApiKey = "MockInvalidApiKey"
        case cityNotFound = "MockCityNotFound"
    }
    
    var jsonFileName = JsonFileName.successData
    
    override func fetchOWMWeather(_ config: ApiConfig) -> Observable<RequestStatus> {
        return super.fetchOWMWeather(config)
    }
    
    //Use mock response data based on the
    override func networkRequest(_ config: ApiConfig, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        guard let json = JsonFileLoader.loadJson(fileName: jsonFileName.rawValue) as? [String: Any] else {
            completionHandler(nil, RequestError("Parse Weather information failed."))
            return
        }
        completionHandler(json, nil)
    }
}


class JsonFileLoader {
    
    class func loadJson(fileName: String) -> Any? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    return try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        } else {
            print("invalid url")
        }
        return nil
    }
}
