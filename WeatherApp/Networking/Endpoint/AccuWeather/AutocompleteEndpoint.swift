//
//  AutocompleteEndpoint.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import Alamofire
import Foundation

struct AutocompleteEndpoint {
    static let url = "http://dataservice.accuweather.com/locations/v1/cities/autocomplete"

    static func parameters(for query: String) -> Parameters {
        ["apikey": NetworkingClient.accuWeatherKey,
         "language": "pl-pl",
         "q": query]
    }
}
