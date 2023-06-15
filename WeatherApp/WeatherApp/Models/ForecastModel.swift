//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 15/06/2023.
//

import Foundation

struct ForecastModel    {
    
    let minTemp : Double
    let maxTemp : Double
    let conditionID : Int
    
    var minTempString : String {
        return String(format: "%.1f", minTemp)
    }
    
    var maxTempString : String {
        return String(format: "%.1f", maxTemp)
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
