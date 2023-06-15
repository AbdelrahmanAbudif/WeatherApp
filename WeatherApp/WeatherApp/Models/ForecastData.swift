//
//  ForecastData.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 15/06/2023.
//

import Foundation
struct ForecastData : Codable {
    let list : [List]
    
}

struct List : Codable{
    let main : Main
    let weather : [Weather]
}

