//
//  CityWeatherDetailsViewController.swift
//  GoodDay
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityWeatherDetailsViewController: UIViewController {

    @IBOutlet var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet var cityWeatherDetailsView: CityWeatherDetailsView!
    public var cityId: Int?


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cityId = cityId else { return }
        cityWeatherDetailsView.cityId = cityId
        navigationItem.backBarButtonItem?.title = ""
    }

    @IBAction func refreshButtonSelected(_ sender: Any) {
        guard let cityId = cityId else { return }
        cityWeatherDetailsView.cityId = cityId
    }
    
    private func bindUI(){
        refreshBarButtonItem.rx.tap
    }
}

