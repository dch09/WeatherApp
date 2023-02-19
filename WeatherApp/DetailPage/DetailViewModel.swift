//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import Foundation

enum Metrics {
    case celsius
    case fahrenheit
}

enum WeatherType {
    case cloudy
    case sunny
    case rainy
    case storm
}

struct HourForecast {
    let hour: Int
    let degrees: Int
    let metrics: Metrics = .celsius
}

struct DayForecast {
    let day: String
    let weatherType: WeatherType
    let highestDegree: Int
    let lowestDegree: Int
    let averageDegree: Int
}

class DetailViewModel {
    let city: String

    let currentTemp: Double
    let highestTemp: Double
    let lowestTemp: Double
    let feelsLike: Double
    let weatherType: WeatherType

    // var sunset: Date
    // var sunrise: Date
    let hourlyForecast: [HourForecast]
    let tenDaysForecast: [DayForecast]

    init(from response: WeatherDataResponse) {
        self.city = response.name
        self.currentTemp = response.main.temp
        self.lowestTemp = response.main.tempMin
        self.highestTemp = response.main.tempMax
        self.feelsLike = response.main.feelsLike
        self.weatherType = .cloudy
        self.hourlyForecast = []
        self.tenDaysForecast = []
    }
}
