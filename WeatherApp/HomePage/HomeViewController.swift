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
        if #available(iOS 15.0, *) {
            resultList.sectionHeaderTopPadding = 0
        }

        print(Storage.shared.bookmarks.count)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.filterOutBookmarks()
        resultList.reloadData()
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

// MARK: - HomeViewController + UITableViewDelegate & DataSource -

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmarksAvailable = !Storage.shared.isEmpty
        let resultsAvailable = !viewModel.searchResults.isEmpty
        let city: String?

        switch (bookmarksAvailable, resultsAvailable) {
        case (true, true):
            switch indexPath.section {
            case 0:
                city = Storage.shared.bookmarks[safe: indexPath.row]
            case 1:
                city = viewModel.searchResults[safe: indexPath.row]?.localizedName
            default:
                city = nil
            }
        case (true, false):
            city = Storage.shared.bookmarks[safe: indexPath.row]
        case (false, true):
            city = viewModel.searchResults[safe: indexPath.row]?.localizedName
        case (false, false):
            city = nil
        }

        guard let city else { return }

        viewModel.openWeatherDetails(for: city)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let bookmarksAvailable = !Storage.shared.isEmpty
        let resultsAvailable = !viewModel.searchResults.isEmpty

        if section == 0, bookmarksAvailable {
            return "Bookmarks"
        } else if section == 1, resultsAvailable {
            return "Search Results"
        }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let bookmarksAvailable = !Storage.shared.isEmpty
        let resultsAvailable = !viewModel.searchResults.isEmpty

        switch (bookmarksAvailable, resultsAvailable) {
        case (false, true), (true, false):
            return 1
        case (true, true):
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Storage.shared.bookmarks.count
        case 1:
            return viewModel.searchResults.count
        default:
            return 0
        }
    }

    private func configureCell(with model: CityModel, cell: UITableViewCell) -> UITableViewCell {
        cell.accessoryType = .disclosureIndicator

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = model.name
            content.secondaryText = model.country
            if model.isBookmarked {
                let image = UIImage(named: "bookmarkIconFill")
                let resizedImage = image?.resized(to: CGSize(width: 24, height: 24))
                content.image = resizedImage
            }
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.country
        }

        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult", for: indexPath)

        switch indexPath.section {
        case 0:
            guard let city = Storage.shared.bookmarks[safe: indexPath.row] else { return cell }
            let model = CityModel(name: city, country: nil, isBookmarked: true)
            return configureCell(with: model, cell: cell)
        case 1:
            guard let city = viewModel.searchResults[safe: indexPath.row] else { return cell }
            let model = CityModel(name: city.localizedName, country: city.country?.localizedName)
            return configureCell(with: model, cell: cell)
        default:
            return cell
        }
    }
}

// MARK: - HomeViewController + HomeViewPresentation -

extension HomeViewController: HomeViewPresentation {
    func openDetailsFor(city: String, with data: CurrentWeatherResponse) {
        let viewModel = DetailViewModel(from: data, city: city)
        let detailVC = DetailViewController(viewModel: viewModel)

        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func showValidationMessage(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.searchField.showMessage(message)
        }
    }

    func hideValidationMessage() {
        DispatchQueue.main.async { [weak self] in
            self?.searchField.hideMessage()
        }
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.resultList.reloadData()
        }
    }
}
