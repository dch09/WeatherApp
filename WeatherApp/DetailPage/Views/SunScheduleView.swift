//
//  SunScheduleView.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

class SunScheduleView: UIView {
    private var stackView = UIStackView()
    private var header = UIView()
    private var icon = UIImageView()
    private var title = UILabel()
    private var time = UILabel()

    // MARK: - Init -

    init(for schedule: SunSchedule) {
        super.init(frame: .zero)

        switch schedule {
        case .sunset(let date):
            icon.image = UIImage(named: "sunsetIcon")
            time.text = date.formatted
        case .sunrise(let date):
            icon.image = UIImage(named: "sunriseIcon")
            time.text = date.formatted
        }

        layer.cornerRadius = 8
        clipsToBounds = true

        title.text = schedule.label
        icon.contentMode = .scaleAspectFit

        addBlur()
        setupStackView()

        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(time)

        header.addSubview(icon)
        header.addSubview(title)

        layoutViews()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views -

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
    }

    // MARK: - Layout Views -

    private func layoutViews() {
        stackView.anchor(to: self, insets: .standard)

        icon.anchor(top: header.topAnchor,
                    left: header.leftAnchor,
                    bottom: header.bottomAnchor,
                    width: 24,
                    height: 24)
        title.anchor(top: icon.topAnchor,
                     left: icon.rightAnchor,
                     bottom: icon.bottomAnchor,
                     right: header.rightAnchor,
                     paddingLeft: 8)
    }
}

private extension Date {
    var formatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
