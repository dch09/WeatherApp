//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

class DetailViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

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
        let isBookmarked = Storage.shared.isBookmarked(viewModel.city)
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
        setupIcon()
        setupTemperatures()
        setupSunScheduleInfo()
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

    private func setupSunScheduleInfo() {
        sunriseInfo = SunScheduleView(for: .sunrise(viewModel.sunrise))
        sunsetInfo = SunScheduleView(for: .sunset(viewModel.sunset))
        guard sunriseInfo != nil, sunsetInfo != nil else { return }
        view.addSubview(sunriseInfo!)
        view.addSubview(sunsetInfo!)
    }

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
        icon.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                    left: view.safeAreaLayoutGuide.leftAnchor,
                    right: view.safeAreaLayoutGuide.rightAnchor,
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

        sunriseInfo?.anchor(top: maxTemp.bottomAnchor,
                            left: view.safeAreaLayoutGuide.leftAnchor,
                            right: view.centerXAnchor,
                            paddingTop: 16,
                            paddingLeft: 16,
                            paddingRight: -16)
        sunsetInfo?.anchor(top: sunriseInfo?.topAnchor,
                           left: view.centerXAnchor,
                           right: view.safeAreaLayoutGuide.rightAnchor,
                           paddingRight: -16)
    }
}

extension DetailViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateBackground()
        }
    }
}
