//
//  Storage.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 20/02/2023.
//

import Foundation

struct CityModel {
    let name: String
    let country: String?
    var isBookmarked = false
}

struct Storage {
    private let bookmarksKey = "bookmarkedCities"
    private let defaults = UserDefaults.standard

    static var shared = Storage()

    // MARK: - Public -

    func toggleBookmark(for city: String) {
        if isBookmarked(city) {
            removeBookmark(for: city)
        } else {
            addBookmark(for: city)
        }
    }

    func isBookmarked(_ city: String) -> Bool {
        bookmarks.contains(city)
    }

    var isEmpty: Bool {
        getBookmarks().isEmpty
    }


    var bookmarks: [String] {
        getBookmarks()
    }

    // MARK: - Private -

    private func addBookmark(for city: String) {
        var bookmarks = getBookmarks()
        bookmarks.append(city)
        saveToDefaults(bookmarks: bookmarks)
    }

    private func removeBookmark(for city: String) {
        var bookmarks = getBookmarks()
        bookmarks.removeAll { $0 == city }
        saveToDefaults(bookmarks: bookmarks)
    }

    private func getBookmarks() -> [String] {
        guard let bookmarks = defaults.array(forKey: bookmarksKey) as? [String] else { return [] }
        return bookmarks
    }

    private func saveToDefaults(bookmarks: [String]) {
        defaults.set(bookmarks, forKey: bookmarksKey)
    }
}
