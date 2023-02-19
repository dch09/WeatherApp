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
        return ["lat": coordinates.latitude,
                "lon": coordinates.longitude,
                "appid": NetworkingClient.openWeatherKey,
                "units": "metric"]
    }
}
