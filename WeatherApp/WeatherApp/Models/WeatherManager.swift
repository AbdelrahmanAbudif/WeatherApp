//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 14/06/2023.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
    func didFailWithError(error:Error)
    func didUpdateForecast(_ weatherManager:WeatherManager , forecast : [ForecastModel])
    func didFailResponse(response : HTTPURLResponse)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=2fc18a15f5a47e1f9642f74cf10f5ebf"
    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=2fc18a15f5a47e1f9642f74cf10f5ebf"
    
    var delegate : WeatherManagerDelegate?
    
    func getWeatherByCityName(cityName:String) {
        let url = "\(weatherURL)&q=\(cityName)"
        performRequest(url:url)
        
    }
    
    func getWeatherByCoordinate(longitude:CLLocationDegrees, latitude:CLLocationDegrees) {
        let url = "\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
        performRequest(url:url)
    }
    func getForecast(cityName : String) {
        let url = "\(forecastURL)&q=\(cityName)"
        performForecastRequest(url: url)
    }
    
    func performRequest(url : String) {
        print(url)
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data , response , error )in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200{
                        self.delegate?.didFailResponse(response: response)
                    }
                }
                if error != nil{
                    
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weather: safeData){
                    self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    func performForecastRequest(url : String) {
        print(url)
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data , response , error )in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200{
                        self.delegate?.didFailResponse(response: response)
                    }
                }
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    print(response.hashValue)
                    if let forecast = self.parseForecastJSON(forecastData: safeData){
                        print(forecast)
                       self.delegate?.didUpdateForecast(self, forecast: forecast)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    func parseForecastJSON(forecastData : Data) -> [ForecastModel]?  {
        let decoder = JSONDecoder()
        var forecastModel :[ForecastModel] = []
        do{
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            for i in stride(from: 0, to: decodedData.list.count, by:  8){
                let minTemp = decodedData.list[i].main.temp_min
                let maxTemp = decodedData.list[i].main.temp_max
                let conditionID = decodedData.list[i].weather[0].id
                let forecast = ForecastModel(minTemp: minTemp
                                             , maxTemp: maxTemp, conditionID: conditionID)
                forecastModel.append(forecast)
            }
            return forecastModel

        }
        catch{
            print(error)
            return nil
        }
    }
    
    
    
    func parseJSON(weather : Data) -> WeatherModel?  {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weather)
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            let humidity = decodedData.main.humidity
            let windSpeed = decodedData.wind.speed
            let windDeg = decodedData.wind.deg
            let id = decodedData.weather[0].id
            let currentWeather = WeatherModel(conditionID: id, temp: temp
                                              , cityName: cityName
                                              , humidity: humidity, windSpeed: windSpeed, windDegrees: windDeg)
            print(currentWeather)
            return currentWeather
        }
        catch{
            print(error)
            return nil
        }
    }
}
