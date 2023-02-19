//
//  SunSchedule.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import Foundation

enum SunSchedule {
    case sunset(Date)
    case sunrise(Date)

    var label: String {
        switch self {
        case .sunset:
            return "Sunset"
        case .sunrise:
            return "Sunrise"
        }
    }
}
