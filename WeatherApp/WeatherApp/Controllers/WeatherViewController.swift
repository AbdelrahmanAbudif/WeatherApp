//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 14/06/2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var foreCastTableView: UITableView!
    @IBOutlet weak var conditionImageView: UIImageView!
    

    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var forecast : [ForecastModel] = []
    var forecastDays : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //creates an empty image as background to remove weird looking borders.
        countrySearchBar.backgroundImage = UIImage()
        countrySearchBar.delegate = self
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        forecastDays  = Date().forecastDaysString()
        foreCastTableView.dataSource = self
        foreCastTableView.register(UINib(nibName: "ForecastCellTableViewCell", bundle: nil), forCellReuseIdentifier: "forecastCell")
        foreCastTableView.delegate = self


        // Do any additional setup after loading the view.
    }
    
    @IBAction func locationButton(_ sender: Any) {
        locationManager.requestLocation()
    }
    
}

//Mark: - Search Bar Delegate
extension WeatherViewController : UISearchBarDelegate{
    
   
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.searchTextField.text != nil
        {
           return true
        }
        else{
            searchBar.searchTextField.text = "Enter a city name!"
        }
        return false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.searchTextField.text != nil
        {
            weatherManager.getWeatherByCityName(cityName: searchBar.searchTextField.text!)
            weatherManager.getForecast(cityName: searchBar.searchTextField.text!)
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
        else{
            searchBar.searchTextField.text = "Enter a city name!"
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        searchBar.searchTextField.text = ""
    }
}

//Mark: - CLLocation Manager delegate

extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            weatherManager.getWeatherByCoordinate(longitude: location.coordinate.longitude, latitude: location.coordinate
                                                    .latitude)
            weatherManager.getForecast(cityName: cityLabel.text!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error)
    }
}

extension WeatherViewController : WeatherManagerDelegate{
    func didFailResponse(response: HTTPURLResponse) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Network Issue", message: "Please make sure the city name is correct!", preferredStyle:   .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    guard self?.presentedViewController == alert else { return }

                    self?.dismiss(animated: true, completion: nil)
                }
        
        }
        
    }
    
    func didUpdateForecast(_ weatherManager: WeatherManager, forecast: [ForecastModel]) {
        DispatchQueue.main.async {
            self.forecast = forecast
            self.foreCastTableView.reloadData()
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            print(weather.conditionName)
            self.conditionImageView.image = UIImage(systemName:  weather.conditionName)
            self.windSpeed.text = "\(weather.windSpeedString)m/s"
            self.humidityLabel.text = "H:\(weather.humidityString)"
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Server Issue", message: "It seems that something is wrong, Try again!", preferredStyle:   .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension WeatherViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastCellTableViewCell
        cell.conditionCellImage.image = UIImage(systemName: forecast[indexPath.row].conditionName)
        cell.dayCellLabel.text = forecastDays[indexPath.row]
        cell.minTempLabel.text = forecast[indexPath.row].minTempString
        cell.maxTempLabel.text = forecast[indexPath.row].maxTempString
        return cell
}
    
}

extension WeatherViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
}

extension  Date {
    func forecastDaysString() -> [String]{
        var forecasteDays : [String] = []
        let  dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let today = Date()
        forecasteDays.append(dateFormatter.string(from: today))
        for i in 1...4{
        let nextDay = Calendar.current.date(byAdding: .day, value: i, to: today)
            forecasteDays.append(dateFormatter.string(from: nextDay!))
        }
        return forecasteDays
    }
    
    
}




