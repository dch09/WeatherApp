//
//  UIView+Blur.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

extension UIView {
    func addBlur(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
}
