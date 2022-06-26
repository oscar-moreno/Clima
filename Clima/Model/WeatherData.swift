import Foundation

struct WeatherData: Codable {
  let weather: [Weather]
  let main: Main
  let name: String
}

struct Main: Codable {
  let temp: Double
}

struct Weather: Codable {
  let id: Int
  let main: String
  let description: String
}
