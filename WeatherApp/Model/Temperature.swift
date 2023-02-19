//
//  Temperature.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import Foundation

typealias Temperature = Double
extension Temperature {
    var localizedString: String {
        let rounded = Int(self.rounded())
        let celsius = "\(rounded)°C"
        let fahrenheit = "\(rounded)°F"

        if #available(iOS 16, *) {
            if Locale.current.measurementSystem == .metric {
                return celsius
            } else {
                return fahrenheit
            }
        } else {
            if Locale.current.usesMetricSystem {
                return celsius
            } else {
                return fahrenheit
            }
        }
    }
}
