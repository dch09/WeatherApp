//
//  WeatherType.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

enum WeatherType {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case fog
    case clear
    case clouds

    init?(code: Int) {
        switch code {
        case 200...232:
            self = .thunderstorm
        case 300...321:
            self = .drizzle
        case 500...531:
            self = .rain
        case 600...622:
            self = .snow
        case 701...781:
            self = .fog
        case 800:
            self = .clear
        case 801...804:
            self = .clouds
        default:
            return nil
        }
    }

    var emoji: String {
        switch self {
        case .thunderstorm:
            return "🌩️"
        case .drizzle:
            return "🌂"
        case .rain:
            return "🌧️"
        case .snow:
            return "🌨️"
        case .fog:
            return "😶‍🌫️"
        case .clear:
            return "☀️"
        case .clouds:
            return "☁️"
        }
    }

    var gradient: Gradient {
        switch self {
        case .thunderstorm:
            let startColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1.0) // Dark gray
            let endColor = UIColor(red: 0.29, green: 0.76, blue: 0.96, alpha: 1.0) // Electric blue
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        case .drizzle:
            let startColor = UIColor(red: 0.69, green: 0.76, blue: 0.79, alpha: 1.0) // Light gray
            let endColor = UIColor(red: 0.43, green: 0.51, blue: 0.56, alpha: 1.0) // Dark slate blue
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        case .rain:
            let startColor = UIColor(red: 0.44, green: 0.51, blue: 0.58, alpha: 1.0) // Slate gray
            let endColor = UIColor(red: 0.27, green: 0.51, blue: 0.71, alpha: 1.0) // Steel blue
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        case .snow:
            let startColor = UIColor(red: 0.94, green: 0.95, blue: 1.00, alpha: 1.0) // Lavender
            let endColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0) // Light gray
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        case .fog:
            let startColor = UIColor(red: 0.69, green: 0.73, blue: 0.76, alpha: 1.0) // Gainsboro
            let endColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0) // Light gray
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        case .clear:
            let startColor = UIColor(red: 1.00, green: 0.84, blue: 0.26, alpha: 1.0) // Sunflower yellow
            let endColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0) // Sky blue
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        case .clouds:
            let startColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.0) // Light gray
            let endColor = UIColor(red: 0.30, green: 0.65, blue: 1.00, alpha: 1.0) // Cool blue
            return Gradient(start: startColor.cgColor, end: endColor.cgColor)
        }
    }
}

struct Gradient {
    let start: CGColor
    let end: CGColor
}
