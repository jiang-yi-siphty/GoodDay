//
//  WeatherListTableViewController.swift
//  GoodDay
//
//  Created by Yi JIANG on 22/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherListTableViewController: UITableViewController {
    
    fileprivate let disposeBag = DisposeBag()
    var cityIds: [Int]?
    var selectedCellIndexPath: IndexPath?
    var citiesViewModel: CitiesViewModel? {
        didSet {
            bindViewModel()
        }
    }
    @IBOutlet weak var refreshBarbuttonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        citiesViewModel = CitiesViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                destinationVC.title = cell.cityNameLabel.text
                destinationVC.cityId = cell.cityId
            }
        }
    }
    
    // MARK: ViewModel Binding
    fileprivate func bindViewModel() {
        tableView.dataSource = nil
        citiesViewModel?.cityIds.asObservable().bind(to: tableView.rx.items(cellIdentifier: "CityWeathTableViewCell", cellType: CityWeatherTableViewCell.self)) { (_ , cityId, cell) in
            cell.cityId = cityId
        }
        .disposed(by: disposeBag)
        
        refreshBarbuttonItem.rx.tap.asObservable().subscribe(onNext: { () in
            self.citiesViewModel = CitiesViewModel()
        }, onError: { error in
            print("error: \(error.localizedDescription)")
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
