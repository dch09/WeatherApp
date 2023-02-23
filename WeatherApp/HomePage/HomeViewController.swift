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
        guard let city = city(at: indexPath) else { return }
        viewModel.openWeatherDetails(for: city)
    }

    private func city(at indexPath: IndexPath) -> CityModel? {
        let bookmarks = Storage.shared.bookmarks
        let results = viewModel.searchResults

        switch (!bookmarks.isEmpty, !results.isEmpty) {
        case (true, true):
            switch indexPath.section {
            case 0:
                return bookmarks[safe: indexPath.row]
            case 1:
                guard let result = results[safe: indexPath.row] else { return nil }
                return CityModel(from: result)
            default:
                return nil
            }
        case (true, false):
            return bookmarks[safe: indexPath.row]
        case (false, true):
            guard let result = results[safe: indexPath.row] else { return nil }
            return CityModel(from: result)
        case (false, false):
            return nil
        }
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
        let bookmarksCount = Storage.shared.bookmarks.count
        let bookmarksAvailable = bookmarksCount > 0
        let resultsCount = viewModel.searchResults.count
        let resultsAvailable = resultsCount > 0

        switch section {
        case 0:
            return bookmarksAvailable ? bookmarksCount : resultsCount
        case 1:
            return bookmarksAvailable ? resultsCount : 0
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
        let bookmarksAvailable = !Storage.shared.bookmarks.isEmpty

        switch indexPath.section {
        case 0:
            if bookmarksAvailable {
                guard let city = Storage.shared.bookmarks[safe: indexPath.row] else { return cell }
                return configureCell(with: city, cell: cell)
            } else {
                guard let city = viewModel.searchResults[safe: indexPath.row] else { return cell }
                return configureCell(with: CityModel(from: city), cell: cell)
            }
        case 1:
            if bookmarksAvailable {
                guard let result = viewModel.searchResults[safe: indexPath.row] else { return cell }
                let city = CityModel(from: result)
                return configureCell(with: city, cell: cell)
            } else {
                return cell
            }
        default:
            return cell
        }
    }
}

// MARK: - HomeViewController + HomeViewPresentation -

extension HomeViewController: HomeViewPresentation {
    func openDetailsFor(city: CityModel, with data: CurrentWeatherResponse) {
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
