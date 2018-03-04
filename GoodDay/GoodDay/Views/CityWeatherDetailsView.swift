//
//  WeatherMainDetailsView.swift
//  GoodDay
//
//  Created by Yi JIANG on 21/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CityWeatherDetailsView: UIView {

    @IBOutlet var countryFlagLabel: UILabel!
    @IBOutlet var cityStateCountryLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var minMaxTemperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    var viewModel: WeatherViewModel?{
        didSet {
            setupBinds()
        }
    }
    
    public var cityId: Int? {
        didSet {
            imageIndicatorStart()
            configViewModel()
        }
    }
    
    var cityNameString = ""
    var countryCode = ""
    var weatherMainDetails: Main? {
        didSet{
            updateWeatherMainDetailsUIs()
        }
    }
    
    var tempMin = 0 {
        didSet {
            updateMinMaxTemperatureLabel()
        }
    }
    
    var tempMax = 0 {
        didSet {
            updateMinMaxTemperatureLabel()
        }
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageIndicatorStart()
        dateLabel.text = getDate()
        monthLabel.text = getMonth()
    }
    
    func configViewModel() {
        guard let cityId = cityId else { return }
        viewModel = WeatherViewModel(ApiClient(), with: cityId)
    }
    
    func setupBinds() {
        viewModel?.city.asObservable()
            .subscribe(onNext: { cityName in
                self.cityNameString = cityName
                DispatchQueue.main.async {
                    self.updateCityCountryLabel()
                }
            }, onError: { error in
                print(error.localizedDescription)
                self.showErrorAlert(error)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel?.country.asObservable()
            .subscribe(onNext: { countryCode in
                self.countryCode = countryCode
                DispatchQueue.main.async {
                    self.updateCityCountryLabel()
                }
            }, onError: { error in
                print(error.localizedDescription)
                self.showErrorAlert(error)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel?.weatherDescription.asObservable()
            .bind(to: weatherDescription.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.main.asObservable()
            .subscribe(onNext: { weatherMain in
                self.weatherMainDetails = weatherMain
            }, onError: { error in
                print(error.localizedDescription)
                self.showErrorAlert(error)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel?.wind.asObservable().subscribe(onNext: { wind in
            if let windSpeed = wind?.speed {
                DispatchQueue.main.async {
                    self.updateWindUi(windSpeed)
                }
            }
        }, onError: { error in
            print(error.localizedDescription)
            self.showErrorAlert(error)
        }, onCompleted: nil, onDisposed: nil)
        
        viewModel?.weatherIconName.asObservable().subscribe(onNext: { iconName in
            DispatchQueue.main.async {
                self.updateIconImage(iconName)
            }
        }, onError: { error in
            print(error.localizedDescription)
            self.showErrorAlert(error)
        }, onCompleted: nil, onDisposed: nil)
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    func getMonth() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    func getFlagEmoji(_ countryCode:String) -> String {
        let base : UInt32 = 127397
        var flagString = ""
        countryCode.unicodeScalars.forEach { scalar in
            flagString.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        return String(flagString)
    }
    
    func getCountryName(_ countryCode:String) -> String {
        guard let countryName = Locale.current.localizedString(forRegionCode: countryCode) else { return "Unknown Country"}
        return countryName
    }
   
    // MARK: update UI
    fileprivate func updateCityCountryLabel() {
        cityStateCountryLabel.text = cityNameString + ", " + getCountryName(countryCode)
        countryFlagLabel.text = getFlagEmoji(countryCode)
    }
    
    fileprivate func updateMinMaxTemperatureLabel() {
        minMaxTemperatureLabel.text = "Min: \(tempMin)℃  Max: \(tempMax)℃"
    }
    
    fileprivate func updateWeatherMainDetailsUIs() {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String.init(format: "%.1f", self.weatherMainDetails?.temp ?? 0.0)
            self.tempMax = self.weatherMainDetails?.tempMax ?? 0
            self.tempMin = self.weatherMainDetails?.tempMin ?? 0
            self.pressureLabel.text = "Pressure: \(self.weatherMainDetails?.pressure ?? 0)mmHg"
            self.humidityLabel.text = "Humidity: \(self.weatherMainDetails?.humidity ?? 0)%"
        }
    }
    
    fileprivate func updateWindUi(_ speed: Float) {
        self.windSpeedLabel.text = String.init(format: "Wind: %.1fkm/h", speed)
    }
    
    fileprivate func updateIconImage(_ iconName: String) {
        guard iconName != "" else { return }
        if let url = URL(string: "https://openweathermap.org/img/w/\(iconName).png") {
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.kf.setImage(with: url)
        }
    }
    
    fileprivate func imageIndicatorStart() {
        iconImageView.contentMode = .scaleAspectFill
        let p = Bundle.main.path(forResource: "LoadingWeatherIndicator", ofType: "gif")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: p))
        iconImageView.kf.indicatorType = .image(imageData: data)
        iconImageView.kf.indicator?.startAnimatingView()
    }
    
    fileprivate func showErrorAlert(_ error: Error){
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "🚧🚨" + error.localizedDescription + "👷🏼🚧", message: nil, preferredStyle: .alert)
//            let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//        }
    }
}

