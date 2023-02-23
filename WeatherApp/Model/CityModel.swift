//
//  CityModel.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 22/02/2023.
//

import Foundation

struct CityModel: Codable {
    let name: String
    let country: String?
    var isBookmarked = false

    init(from response: AutocompleteResponse) {
        self.name = response.localizedName
        self.country = response.country?.localizedName
        self.isBookmarked = false
    }
}
