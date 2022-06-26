import Foundation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=af6dd971db158668eb339571643a5405"
  
  var delegate: WeatherManagerDelegate?
  
  func fetchWeather (cityName: String) {
    let weatherUrl = "\(baseUrl)&q=\(cityName)"
    performRequest(with: weatherUrl)
  }
  
  func fetchWeather (latitude: Double, longitude: Double) {
    let weatherUrl = "\(baseUrl)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: weatherUrl)
  }
  
  func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
          
        }
      }
      task.resume()
    }
  }
  
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let city = decodedData.name
      let temp = decodedData.main.temp
      
      let weather = WeatherModel(conditionId: id, cityName: city, temperature: temp)
      return weather
      
    } catch {
      delegate?.didFailWithError(error: error)
      
      return nil
    }
  }
  
}

