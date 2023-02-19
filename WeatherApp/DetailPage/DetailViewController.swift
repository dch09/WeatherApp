//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

class DetailViewController: UIViewController {
    private var icon = UILabel()
    private var currentTemp = UILabel()
    private var maxTemp = UILabel()
    private var minTemp = UILabel()
    private var feelsLike = UILabel()

    private var sunsetInfo: SunScheduleView?
    private var sunriseInfo: SunScheduleView?

    private var viewModel: DetailViewModel!

    // MARK: - Init -

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.city
        setupBackground()
        setupViews()
        layoutViews()
    }

    // MARK: - Setup -

    private func setupViews() {
        setupIcon()
        setupTemperature()
        setupSunScheduleInfo()
    }

    private func setupIcon() {
        guard let emoji = viewModel.weatherType?.emoji else { return }
        icon.text = emoji
        icon.font = .systemFont(ofSize: 64)
        icon.textAlignment = .center
        view.addSubview(icon)
    }

    private func setupTemperature() {
        currentTemp.font = .systemFont(ofSize: 48)
        currentTemp.textColor = .darkText
        currentTemp.textAlignment = .center
        currentTemp.text = viewModel.currentTemp.localizedString
        view.addSubview(currentTemp)
    }

    private func setupSunScheduleInfo() {
        sunriseInfo = SunScheduleView(for: .sunrise(viewModel.sunrise))
        sunsetInfo = SunScheduleView(for: .sunset(viewModel.sunset))
        guard sunriseInfo != nil, sunsetInfo != nil else { return }
        view.addSubview(sunriseInfo!)
        view.addSubview(sunsetInfo!)
    }

    private func setupBackground() {
        view.backgroundColor = .clear
        if let weatherType = viewModel.weatherType {
            view.layer.addSublayer(CAGradientLayer.gradientLayer(for: weatherType, in: view.frame))
        }
    }

    // MARK: - Layout -

    private func layoutViews() {
        icon.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                    left: view.safeAreaLayoutGuide.leftAnchor,
                    right: view.safeAreaLayoutGuide.rightAnchor,
                    paddingTop: 32)
        currentTemp.anchor(top: icon.bottomAnchor,
                           left: icon.leftAnchor,
                           right: icon.rightAnchor,
                           paddingTop: 8)

        sunriseInfo?.anchor(top: currentTemp.bottomAnchor,
                            left: currentTemp.leftAnchor,
                            right: view.centerXAnchor,
                            paddingTop: 16,
                            paddingLeft: 8,
                            paddingRight: -8)
        sunsetInfo?.anchor(top: sunriseInfo?.topAnchor,
                           left: view.centerXAnchor,
                           right: currentTemp.rightAnchor,
                           paddingRight: -8)
    }
}
