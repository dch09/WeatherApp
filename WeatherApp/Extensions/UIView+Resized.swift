//
//  UIView+Resized.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 21/02/2023.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let scale = min(widthRatio, heightRatio)

        let newWidth = self.size.width * scale
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
