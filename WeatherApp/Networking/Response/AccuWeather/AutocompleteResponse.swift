//
//  AutocompleteResponse.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import Foundation

struct AutocompleteResponse: Decodable {
    let type: String
    let rank: Int
    let localizedName: String
    var country: Country?
    var administrativeArea: AdministrativeArea?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea

struct AdministrativeArea: Decodable {
    let id: String
    let localizedName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}

// MARK: - Country

struct Country: Decodable {
    let id: String
    let localizedName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}
