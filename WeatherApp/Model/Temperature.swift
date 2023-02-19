//
//  Temperature.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import Foundation

typealias Temperature = Double

extension Temperature {
    var degreeFormat: String {
        let rounded = Int(self.rounded())
        return "\(rounded)°C"
    }
}
