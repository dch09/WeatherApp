//
//  GeocodingEndpoint.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import Alamofire
import Foundation

struct GeocodingEndpoint {
    static let url = "http://api.openweathermap.org/geo/1.0/direct"

    static func parameters(city: String, limit: Int = 1) -> Parameters {
        ["q": city,
         "appid": NetworkingClient.openWeatherKey,
         "limit": limit]
    }
}
