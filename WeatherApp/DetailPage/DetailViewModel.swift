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

    let currentTemp: Temperature
    
    private let lowestTemp: Temperature
    var lowestTemperatureLabel: String {
        "Min: \(lowestTemp.degreeFormat)"
    }
    
    private let highestTemp: Temperature
    var highestTemperatureLabel: String {
        "Max: \(highestTemp.degreeFormat)"
    }

    let feelsLike: Temperature
    let weatherType: WeatherType?

    var sunset: Date
    var sunrise: Date

    let hourlyForecast: [HourForecast]
    let tenDaysForecast: [DayForecast]

    init(from response: WeatherDataResponse, city: String) {
        self.city = city

        self.currentTemp = response.main.temp
        self.lowestTemp = response.main.tempMin
        self.highestTemp = response.main.tempMax
        self.feelsLike = response.main.feelsLike
        self.weatherType = WeatherType(code: response.weather.first?.id ?? 0)

        self.sunset = response.sys.sunset.date
        self.sunrise = response.sys.sunrise.date

        self.hourlyForecast = []
        self.tenDaysForecast = []
    }
}

private extension Int {
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }
}
