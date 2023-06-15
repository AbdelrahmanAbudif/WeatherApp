//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 14/06/2023.
//

import Foundation

struct WeatherData:Codable{
    let name : String
    let main : Main
    let wind : Wind
    let weather : [Weather]

}

struct Main:Codable{
    let temp : Double
    let humidity : Int
    let temp_min : Double
    let temp_max :Double
}

struct Wind:Codable{
    let speed : Double
    let deg : Double
}
struct Weather:Codable {
    let id : Int
    let description : String
}


