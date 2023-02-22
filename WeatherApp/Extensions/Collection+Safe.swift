//
//  Collection+Safe.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 22/02/2023.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
