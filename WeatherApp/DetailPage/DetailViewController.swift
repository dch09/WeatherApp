//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 19/02/2023.
//

import UIKit

class DetailViewController: UIViewController {
    private var icon = UIImageView()
    private var currentTemp = UILabel()
    private var maxTemp = UILabel()
    private var minTemp = UILabel()
    private var feelsLike = UILabel()

    private var viewModel: DetailViewModel!

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.city
        view.backgroundColor = .gray
    }

    private func setupViews() {
        
    }

    private func layoutViews() {
        
    }
}
