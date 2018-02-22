//
//  CityWeatherDetailsViewController.swift
//  GoodDay
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit

class CityWeatherDetailsViewController: UIViewController {

    @IBOutlet var cityWeatherDetailsView: CityWeatherDetailsView!
    public var cityId: Int?
    
    func configureView() {
        navigationItem.backBarButtonItem?.title = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        guard let cityId = cityId else { return }
        cityWeatherDetailsView.cityId = cityId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshButtonSelected(_ sender: Any) {
        guard let cityId = cityId else { return }
        cityWeatherDetailsView.cityId = cityId
    }
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

