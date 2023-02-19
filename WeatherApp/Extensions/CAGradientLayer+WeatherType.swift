//
//  CAGradientLayer+WeatherType.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

extension CAGradientLayer {
    static func gradientLayer(for weatherType: WeatherType, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = weatherType.colors
        layer.frame = frame
        return layer
    }
}
