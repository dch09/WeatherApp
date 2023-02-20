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
}

class HomeViewModel {
    weak var presenter: HomeViewPresentation?

    private let debounceDelay = 0.5
    private var debounceTimer: Timer?

    /// observe textField changes with debounced execution
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        if query.isEmpty {
            presenter?.hideValidationMessage()
            return
        }

        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { [weak self] _ in
            guard let self else { return }

            if self.validateCityName(query) {
                self.presenter?.hideValidationMessage()
                self.search(for: query)
            } else {
                self.presenter?.showValidationMessage("Incorrect city name.")
            }
        }
    }

    // private(set) var searchResults: [AutocompleteResponse] = []
    private(set) var searchResults: [AutocompleteResponse] = [
        .init(type: "City", rank: 1, localizedName: "Kraków", country: .init(id: "1", localizedName: "Polska")),
        .init(type: "City", rank: 1, localizedName: "Białystok", country: .init(id: "1", localizedName: "Polska")),
        .init(type: "City", rank: 1, localizedName: "Warszawa", country: .init(id: "1", localizedName: "Polska")),
    ]

    func search(for query: String) {
        // NetworkingClient.shared.search(for: query) { [weak self] result in
        //     switch result {
        //     case .success(let value):
        //         self?.searchResults = value
        //     case .failure(let error):
        //         print(error)
        //     }
        // }
    }

    private func clearSuggestions() {
        searchResults.removeAll()
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
