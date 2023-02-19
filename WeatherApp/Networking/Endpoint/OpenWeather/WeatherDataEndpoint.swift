//
//  WeatherDataEndpoint.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import Alamofire
import Foundation

struct WeatherDataEndpoint {
    static let url = "https://api.openweathermap.org/data/2.5/weather"

    static func parameters(coordinates: NetworkingClient.Coordinates) -> Parameters {
        let isUsingMetricUnits: Bool
        if #available(iOS 16, *) {
            isUsingMetricUnits = Locale.current.measurementSystem == .metric
        } else {
            isUsingMetricUnits = Locale.current.usesMetricSystem
        }

        return ["lat": coordinates.latitude,
                "lon": coordinates.longitude,
                "appid": NetworkingClient.openWeatherKey,
                "units": isUsingMetricUnits ? "metric" : "imperial"]
    }
}
