//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import UIKit

class HomeViewController: UIViewController {
    private var searchbar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        navigationController?.title = "Search"
    }

    private func setupViews() {
        view.addSubview(searchbar)
    }

    private func layoutViews() {
        searchbar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }
}
