//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import Combine
import UIKit

protocol HomeViewPresentation: AnyObject {
    func showValidationMessage(_ message: String)
    func hideValidationMessage()
    func openDetailsFor(city: CityModel, with data: CurrentWeatherResponse)
    func reloadData()
}

class HomeViewModel {
    weak var presenter: HomeViewPresentation?
    private(set) var searchResults: [AutocompleteResponse] = []
    private let debounceDelay = 0.2
    private var debounceTimer: Timer?

    /// observe textField changes with debounced execution
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }

        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { [weak self] _ in
            guard let self else { return }

            if query.isEmpty {
                self.presenter?.hideValidationMessage()
                self.searchResults.removeAll()
                self.presenter?.reloadData()
                return
            }

            if self.validateCityName(query) {
                self.presenter?.hideValidationMessage()
                self.search(for: query)
            } else {
                self.presenter?.showValidationMessage("Incorrect city name.")
            }
        }
    }

    func search(for query: String) {
        NetworkingClient.shared.search(for: query) { [weak self] result in
            switch result {
            case .success(let value):
                self?.updateResults(with: value)
            case .failure(let error):
                print(error)
            }
        }
    }

    /// Filter out bookmarked cities to avoid displaying cities in both bookmarks section and results
    func filterOutBookmarks() {
        searchResults = searchResults.filter { !Storage.shared.isBookmarked($0.localizedName) }
    }
    
    func openWeatherDetails(for city: CityModel) {
        NetworkingClient.shared.getCoordinates(for: city.name) { [weak self] result in
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
                        self?.presenter?.openDetailsFor(city: city, with: value)
                    case .failure(let error):
                        print(error)
                    }
                }

            case .failure(let error):
                print("Show error")
            }
        }
    }

    private func updateResults(with results: [AutocompleteResponse]) {
        /// Filter out bookmarked cities to avoid displaying cities in both bookmarks section and results
        searchResults = results.filter { !Storage.shared.isBookmarked($0.localizedName) }
        presenter?.reloadData()
    }

    /// Validates city name using regex
    /// - Parameter name: city name
    /// - Returns: true if city name is correct, false otherwise
    private func validateCityName(_ name: String) -> Bool {
        let pattern = "^[A-ZĄĆĘŁŃÓŚŹŻa-ząćęłńóśźż]+(?:[\\s-][A-ZĄĆĘŁŃÓŚŹŻa-ząćęłńóśźż]+)*$"

        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: name.utf16.count)
            let matches = regex.matches(in: name, range: range)
            return !matches.isEmpty
        } catch {
            // incorrect regex, shouldn't happen
            return false
        }
    }
}
