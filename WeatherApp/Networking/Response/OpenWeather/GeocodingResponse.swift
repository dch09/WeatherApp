//
//  GeocodingResponse.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//
// swiftlint: disable identifier_name

import Foundation

// MARK: - GeocodingResponse

struct GeocodingResponse: Codable {
    let name: String?
    let localNames: LocalNames?
    let lat, lon: Double?
    let country, state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

// MARK: - LocalNames

struct LocalNames: Codable {
    let en, pl, lt, it: String?
    let hr, ro, sk, ca: String?
    let es, pt, zh, mt: String?
    let be, eu, nl, lv: String?
    let ar, ru, eo, mk: String?
    let el, fr, fa, hu: String?
    let sl, ja, fi, cs: String?
    let sr, uk, la, de: String?
}
