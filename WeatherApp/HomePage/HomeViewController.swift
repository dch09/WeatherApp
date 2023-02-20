//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import UIKit

class HomeViewController: UIViewController {
    private var viewModel = HomeViewModel()
    private var searchField = TextFieldContainer()
    private var resultList = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        title = "WeatherApp"
        navigationController?.navigationBar.prefersLargeTitles = true

        viewModel.presenter = self
        resultList.delegate = self
        resultList.dataSource = self
        resultList.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResult")

        searchField.textField.addTarget(viewModel,
                                        action: #selector(viewModel.textFieldDidChange),
                                        for: .editingChanged)
    }

    private func setupViews() {
        view.addSubview(searchField)
        searchField.setLabelColor(to: .red)
        view.addSubview(resultList)
    }

    private func layoutViews() {
        searchField.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           left: view.safeAreaLayoutGuide.leftAnchor,
                           right: view.safeAreaLayoutGuide.rightAnchor,
                           paddingTop: 8,
                           paddingLeft: 16,
                           paddingRight: -16)
        resultList.anchor(top: searchField.bottomAnchor,
                          left: view.safeAreaLayoutGuide.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          right: view.safeAreaLayoutGuide.rightAnchor,
                          paddingTop: 8,
                          paddingLeft: 0,
                          paddingBottom: 8,
                          paddingRight: 0)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.searchResults[indexPath.row].localizedName

        NetworkingClient.shared.getCoordinates(for: city) { [weak self] result in
            switch result {
            case .success(let value):
                guard let first = value.first,
                      let latitude = first.lat,
                      let longitude = first.lon
                else { return }
                let coordinates = NetworkingClient.Coordinates(latitude: latitude,
                                                               longitude: longitude)

                NetworkingClient.shared.fetchWeather(for: coordinates) { [weak self] result in
                    switch result {
                    case .success(let value):
                        let viewModel = DetailViewModel(from: value, city: city)
                        let detailVC = DetailViewController(viewModel: viewModel)
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    case .failure(let error):
                        print(error)
                    }
                }

            case .failure(let error):
                print("Show error")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: - favorites
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult", for: indexPath)
        let searchResult = viewModel.searchResults[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = searchResult.localizedName
            content.secondaryText = searchResult.country?.localizedName
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = searchResult.localizedName
            cell.detailTextLabel?.text = searchResult.country?.localizedName
        }
        // content.image = book.authType == .single ? UIImage(systemName: "person.fill") : UIImage(systemName: "person.2.fill")
        return cell
    }
}

extension HomeViewController: HomeViewPresentation {
    func showValidationMessage(_ message: String) {
        searchField.showMessage(message)
    }

    func hideValidationMessage() {
        searchField.hideMessage()
    }
}
