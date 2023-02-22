//
//  Date+ShortFormat.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 22/02/2023.
//

import Foundation

extension Date {
    var shortFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
