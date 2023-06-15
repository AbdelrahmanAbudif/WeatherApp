//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 14/06/2023.
//

import Foundation
struct WeatherModel{
    let conditionID : Int
    let temp : Double
    let cityName:String
    let humidity : Int
    let windSpeed : Double
    let windDegrees : Double
    
    
    var temperatureString : String {
        String(format: "%.1f", temp)
    }
    
    var humidityString : String {
        String(format:"%2d" , humidity)
    }
    
    var windSpeedString : String {
        String(format: "%.1f", windSpeed)
    }
    var windDegreesString : String {
        String(format: "%.1f", windDegrees)
    }
    
    
    var conditionName:String
    {
        switch conditionID{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
