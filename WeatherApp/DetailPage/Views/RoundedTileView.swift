//
//  RoundedTileView.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 22/02/2023.
//

import UIKit

class RoundedTileView: UIView {
    private var stackView = UIStackView()
    private var headerWrapper = UIView()

    private var icon = UIImageView()
    private var title = UILabel()
    private var detail = UILabel()

    init() {
        super.init(frame: .zero)
        setupViews()
        layoutViews()
    }

    private func setupViews() {
        layer.cornerRadius = 8
        clipsToBounds = true
        addBlur()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(headerWrapper)
        stackView.addArrangedSubview(detail)
        icon.contentMode = .scaleAspectFit
        headerWrapper.addSubview(icon)
        headerWrapper.addSubview(title)

        addSubview(stackView)
    }

    private func layoutViews() {
        stackView.anchor(to: self, insets: .standard)

        icon.anchor(top: headerWrapper.topAnchor,
                    left: headerWrapper.leftAnchor,
                    bottom: headerWrapper.bottomAnchor,
                    width: 24,
                    height: 24)
        title.anchor(top: icon.topAnchor,
                     left: icon.rightAnchor,
                     bottom: icon.bottomAnchor,
                     right: headerWrapper.rightAnchor,
                     paddingLeft: 8)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with configuration: Configuration) {
        icon.image = configuration.icon
        title.text = configuration.title
        detail.text = configuration.detail
    }
}

extension RoundedTileView {
    struct Configuration {
        let icon: UIImage
        let title: String
        let detail: String
    }
}
