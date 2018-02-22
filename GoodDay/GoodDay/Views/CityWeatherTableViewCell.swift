//
//  CityWeatherTableViewCell.swift
//  GoodDay
//
//  Created by Yi JIANG on 21/2/18.
//  Copyright © 2018 Thred. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    
    var viewModel: WeatherViewModel?
    var cityId: Int = 0 {
        didSet {
            configViewModel()
            setupBinds()
        }
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingActivityIndicator.startAnimating()
        loadingActivityIndicator.isHidden = false
    }
    
    func configViewModel() {
        viewModel = WeatherViewModel(ApiClient(), with: cityId)
    }
    
    func setupBinds() {
        viewModel?.city.asObservable()
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.temperature.asObservable()
            .subscribe(onNext: { temp in
                DispatchQueue.main.async {
                    self.updateTemperatureLabel(temp)
                }
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel?.isIndicatorHiding.asObservable()
            .bind(to: loadingActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func updateTemperatureLabel(_ temp: String) {
        temperatureLabel.text = temp + " ℃"
    }

}
