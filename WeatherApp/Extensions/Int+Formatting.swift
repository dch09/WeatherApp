//
//  Int+Formatting.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 22/02/2023.
//

import Foundation

extension Int {
    var kilometersString: String {
        let kilometers = Double(self) / 1000.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        let kilometersString = formatter.string(from: NSNumber(value: kilometers)) ?? "\(kilometers)"
        return kilometersString + " km"
    }
}
