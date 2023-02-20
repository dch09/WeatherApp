//
//  TextFieldContainer.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 20/02/2023.
//

import UIKit

class TextFieldContainer: UIView {
    private(set) var textField = UITextField()
    private var label = UILabel()

    // MARK: - Init -

    init() {
        super.init(frame: .zero)
        setupViews()
        layoutViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(textField)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search"
        let icon = UIImage(named: "searchSymbol")
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.anchor(width: 32, height: 16)
        textField.leftView = iconView
        textField.leftViewMode = .always

        addSubview(label)
    }

    private func layoutViews() {
        textField.anchor(top: topAnchor,
                         left: leftAnchor,
                         right: rightAnchor)
        label.anchor(top: textField.bottomAnchor,
                     left: textField.leftAnchor,
                     bottom: bottomAnchor,
                     right: textField.rightAnchor,
                     paddingTop: 8)
    }

    func setLabelColor(to color: UIColor) {
        label.textColor = color
    }

    func showMessage(_ message: String) {
        if label.text != message || label.isHidden != false {
            label.text = message
            label.setVisibility(to: .visible)
        }
    }

    func hideMessage() {
        if label.text != "" || label.isHidden != true {
            label.text = ""
            label.setVisibility(to: .hidden)
        }
    }
}
