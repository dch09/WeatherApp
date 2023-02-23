//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

class DetailViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

    private var country = UILabel()
    private var icon = UILabel()
    private var currentTemp = UILabel()
    private var maxTemp = UILabel()
    private var minTemp = UILabel()
    private var feelsLike = UILabel()

    private var sunsetTile = RoundedTileView()
    private var sunriseTile = RoundedTileView()

    private var visibilityTile = RoundedTileView()
    private var cloudsTile = RoundedTileView()
    private var windTile = RoundedTileView()
    private var pressureTile = RoundedTileView()
    private var humidityTile = RoundedTileView()

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
        title = viewModel.city.name
        navigationController?.navigationBar.tintColor = .black
        setupBookmarkButton()
        setupBackground()
        animateBackground()
        setupViews()
        layoutViews()
    }

    // MARK: - Setup -

    private func setupBookmarkButton() {
        // TODO: - fix constraints issues
        let isBookmarked = Storage.shared.isBookmarked(viewModel.city.name)
        let iconName = isBookmarked ? "bookmarkIconFill" : "bookmarkIcon"
        let icon = UIImage(named: iconName)
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.addTarget(self,
                         action: #selector(toggleCityBookmark),
                         for: .touchUpInside)
        button.anchor(width: 24, height: 24)
        button.imageView?.contentMode = .scaleAspectFit

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }

    @objc func toggleCityBookmark(_ sender: UIBarButtonItem) {
        Storage.shared.toggleBookmark(for: viewModel.city)

        DispatchQueue.main.async { [weak self] in
            self?.setupBookmarkButton()
        }
    }

    private func setupViews() {
        setupCountry()
        setupIcon()
        setupTemperatures()
        setupSunriseTile()
        setupSunsetTile()
        setupVisibilityTile()
        setupCloudsTile()
        setupWindTile()
        setupPressureTile()
        setupHumidityTile()
    }

    private func setupCountry() {
        country.text = viewModel.city.country
        country.font = .systemFont(ofSize: 18)
        country.textColor = .black.withAlphaComponent(0.7)
        view.addSubview(country)
    }

    private func setupIcon() {
        guard let emoji = viewModel.weatherType?.emoji else { return }
        icon.text = emoji
        icon.font = .systemFont(ofSize: 64)
        icon.textAlignment = .center
        view.addSubview(icon)
    }

    private func setupTemperatures() {
        currentTemp.font = .systemFont(ofSize: 48)
        currentTemp.textColor = .darkText
        currentTemp.textAlignment = .center
        currentTemp.text = viewModel.currentTemp.degreeFormat
        view.addSubview(currentTemp)

        minTemp.text = viewModel.lowestTemperatureLabel
        minTemp.font = .systemFont(ofSize: 16)
        minTemp.textColor = UIColor.black.withAlphaComponent(0.6)
        minTemp.textAlignment = .right
        view.addSubview(minTemp)

        maxTemp.text = viewModel.highestTemperatureLabel
        maxTemp.font = .systemFont(ofSize: 16)
        maxTemp.textColor = UIColor.black.withAlphaComponent(0.6)
        maxTemp.textAlignment = .left
        view.addSubview(maxTemp)
    }

    private func setupSunriseTile() {
        let icon = UIImage(named: "sunsetIcon")
        sunriseTile.update(with: .init(icon: icon,
                                       title: "Sunrise",
                                       detail: viewModel.sunrise.shortFormat))
        view.addSubview(sunriseTile)
    }

    private func setupSunsetTile() {
        let icon = UIImage(named: "sunriseIcon")
        sunsetTile.update(with: .init(icon: icon,
                                      title: "Sunset",
                                      detail: viewModel.sunset.shortFormat))
        view.addSubview(sunsetTile)
    }

    func setupVisibilityTile() {
        let icon = UIImage(named: "eyeIcon")
        visibilityTile.update(with: .init(icon: icon,
                                          title: "Visibility",
                                          detail: viewModel.visibility.kilometersString))
        view.addSubview(visibilityTile)
    }

    func setupCloudsTile() {
        let icon = UIImage(named: "cloudIcon")
        cloudsTile.update(with: .init(icon: icon,
                                      title: "Cloudiness",
                                      detail: "\(viewModel.clouds) %"))
        view.addSubview(cloudsTile)
    }

    func setupWindTile() {
        let icon = UIImage(named: "windIcon")
        windTile.update(with: .init(icon: icon,
                                    title: "Wind Speed",
                                    detail: "\(viewModel.windSpeed) m/s"))
        view.addSubview(windTile)
    }

    func setupPressureTile() {
        let icon = UIImage(named: "speedometerIcon")
        pressureTile.update(with: .init(icon: icon,
                                        title: "Pressure",
                                        detail: "\(viewModel.pressure) hPa"))
        view.addSubview(pressureTile)
    }

    func setupHumidityTile() {
        let icon = UIImage(named: "humidityIcon")
        humidityTile.update(with: .init(icon: icon,
                                        title: "Humidity",
                                        detail: "\(viewModel.humidity) %"))
        view.addSubview(humidityTile)
    }

    // private var visibilityTile = RoundedTileView()
    // private var cloudsTile = RoundedTileView()
    // private var windTile = RoundedTileView()
    // private var pressureTile = RoundedTileView()
    // private var humidityTile = RoundedTileView()

    // MARK: - Gradient Background -

    private func setupBackground() {
        view.backgroundColor = .clear
        if let weatherType = viewModel.weatherType {
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [weatherType.gradient.start,
                                    weatherType.gradient.end]
            view.layer.addSublayer(gradientLayer)
        }
    }

    private func animateBackground() {
        if let weatherType = viewModel.weatherType {
            let animation = CABasicAnimation(keyPath: "colors")
            animation.delegate = self

            animation.toValue = [weatherType.gradient.end,
                                 weatherType.gradient.start]

            animation.duration = 5
            animation.autoreverses = true
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false

            gradientLayer.add(animation, forKey: "colors")
        }
    }

    // MARK: - Layout -

    private func layoutViews() {
        country.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.safeAreaLayoutGuide.leftAnchor,
                       right: view.safeAreaLayoutGuide.rightAnchor,
                       paddingLeft: 16)

        icon.anchor(top: country.bottomAnchor,
                    left: country.leftAnchor,
                    right: country.rightAnchor,
                    paddingTop: 32)

        currentTemp.anchor(top: icon.bottomAnchor,
                           left: icon.leftAnchor,
                           right: icon.rightAnchor,
                           paddingTop: 8)

        minTemp.anchor(top: currentTemp.bottomAnchor,
                       left: view.safeAreaLayoutGuide.leftAnchor,
                       right: view.centerXAnchor,
                       paddingTop: 8,
                       paddingRight: -16)

        maxTemp.anchor(top: minTemp.topAnchor,
                       left: view.centerXAnchor,
                       right: view.safeAreaLayoutGuide.rightAnchor,
                       paddingLeft: 16)

        sunriseTile.anchor(top: maxTemp.bottomAnchor,
                           left: view.safeAreaLayoutGuide.leftAnchor,
                           right: view.centerXAnchor,
                           paddingTop: 16,
                           paddingLeft: 16,
                           paddingRight: -16)
        sunsetTile.anchor(top: sunriseTile.topAnchor,
                          left: view.centerXAnchor,
                          right: view.safeAreaLayoutGuide.rightAnchor,
                          paddingRight: -16)

        visibilityTile.anchor(top: sunsetTile.bottomAnchor,
                              left: sunriseTile.leftAnchor,
                              right: sunriseTile.rightAnchor,
                              paddingTop: 16)

        cloudsTile.anchor(top: sunsetTile.bottomAnchor,
                          left: sunsetTile.leftAnchor,
                          right: sunsetTile.rightAnchor,
                          paddingTop: 16)

        windTile.anchor(top: visibilityTile.bottomAnchor,
                        left: visibilityTile.leftAnchor,
                        right: visibilityTile.rightAnchor,
                        paddingTop: 16)

        pressureTile.anchor(top: cloudsTile.bottomAnchor,
                            left: cloudsTile.leftAnchor,
                            right: cloudsTile.rightAnchor,
                            paddingTop: 16)

        humidityTile.anchor(top: windTile.bottomAnchor,
                            left: windTile.leftAnchor,
                            right: windTile.rightAnchor,
                            paddingTop: 16)
    }
}

extension DetailViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateBackground()
        }
    }
}
