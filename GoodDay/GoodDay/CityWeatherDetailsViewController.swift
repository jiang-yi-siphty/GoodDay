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
    
    public var navigationBarTitleString: String? 
    public var cityId: Int? {
        didSet {
            cityWeatherDetailsView.cit
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
        title = navigationBarTitleString
        navigationItem.backBarButtonItem?.title = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

