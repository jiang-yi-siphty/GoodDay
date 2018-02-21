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
    
    var cityId: Int = 0
    var viewModel: WeatherViewModel? {
        didSet {
            setupBinds()
        }
    }
    fileprivate let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configViewModel()
        loadingActivityIndicator.startAnimating()
        loadingActivityIndicator.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ apiResponse: ApiResponse?) {
        guard let weather = apiResponse?.weather?.first else { return }
        
    }
    
    func configViewModel() {
        viewModel = WeatherViewModel(ApiClient(), with: cityId)
    }
    
    func setupBinds() {
        viewModel?.city.asObservable()
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.temperature.asObservable()
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.isHiding.asObservable()
            .bind(to: loadingActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }

}
