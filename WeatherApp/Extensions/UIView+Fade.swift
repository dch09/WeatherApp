//
//  UIView+Fade.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 20/02/2023.
//

import UIKit

/// https://stackoverflow.com/a/53143736
extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 1 },
                       completion: { _ in
                           if let complete = onCompletion { complete() }
                       })
    }

    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 0 },
                       completion: { _ in
                           self.isHidden = true
                           if let complete = onCompletion { complete() }
                       })
    }
}

enum Visibility {
    case visible
    case hidden
}

extension UIView {
    func setVisibility(to visiblity: Visibility, withAnimation: Bool = true, duration: TimeInterval = 0.2) {
        switch visiblity {
        case .visible:
            self.fadeIn(duration) { [weak self] in
                self?.isHidden = false
            }
        case .hidden:
            self.fadeOut(duration) { [weak self] in
                self?.isHidden = true
            }
        }
    }
}
