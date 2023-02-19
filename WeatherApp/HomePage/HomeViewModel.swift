//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import Combine
import UIKit

class HomeViewModel {
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

    func clearSuggestions() {
        searchResults.removeAll()
    }
}
