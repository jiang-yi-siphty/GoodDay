//
//  CitiesViewModel.swift
//  GoodDay
//
//  Created by Yi Jiang on 5/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CitiesViewModel {
    
    let cityIdArray = [4163971, 2147714, 2174003]
    let disposeBag = DisposeBag()
    var cityIds = Variable<[Int]>([])
    
    init() {
        fetchCityIds()
    }
    
    func fetchCityIds() {
        //TODO: Should read city ids string from a text file
        //For now, just get the ids from parameters
        cityIds.value = cityIdArray
    }
}
