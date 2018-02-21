//
//  WeatherListTableViewController.swift
//  GoodDay
//
//  Created by Yi JIANG on 22/2/18.
//  Copyright © 2018 Thred. All rights reserved.
//

import UIKit

class WeatherListTableViewController: UITableViewController {
    
    var cityIds = [4163971, 2147714, 2174003]
    var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cityIds.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeathTableViewCell", for: indexPath) as! CityWeatherTableViewCell
        cell.cityId = cityIds[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
        performSegue(withIdentifier: "SegueToCityWeatherDetailsView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToCityWeatherDetailsView" {
            if let destinationVC = segue.destination as? CityWeatherDetailsViewController {
                guard let selectedCellIndexPath = selectedCellIndexPath else { return }
                guard let cell = tableView.cellForRow(at: selectedCellIndexPath) as? CityWeatherTableViewCell else { return }
                destinationVC.navigationBarTitleString = cell.cityNameLabel.text
                destinationVC.cityId = cell.cityId
            }
        }
    }
}
