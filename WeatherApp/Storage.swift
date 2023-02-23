//
//  Storage.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 20/02/2023.
//

import Foundation

struct Storage {
    private let bookmarksKey = "bookmarkedCities"
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    static var shared = Storage()

    // MARK: - Public -

    func toggleBookmark(for city: CityModel) {
        if isBookmarked(city.name) {
            removeBookmark(for: city)
        } else {
            addBookmark(for: city)
        }
    }
    
    func isBookmarked(_ name: String) -> Bool {
        bookmarks.contains(where: { $0.name == name })
    }

    var isEmpty: Bool {
        getBookmarks().isEmpty
    }

    var bookmarks: [CityModel] {
        getBookmarks()
    }

    // MARK: - Private -

    private func addBookmark(for city: CityModel) {
        var bookmarks = getBookmarks()
        var copy = city
        copy.isBookmarked = true
        bookmarks.append(copy)
        saveToDefaults(bookmarks: bookmarks)
    }

    private func removeBookmark(for city: CityModel) {
        var bookmarks = getBookmarks()
        bookmarks.removeAll { $0.name == city.name }
        saveToDefaults(bookmarks: bookmarks)
    }

    private func getBookmarks() -> [CityModel] {
        guard let bookmarksData = defaults.data(forKey: bookmarksKey),
              let bookmarks = try? decoder.decode([CityModel].self, from: bookmarksData) else {
            return []
        }
        return bookmarks
    }

    private func saveToDefaults(bookmarks: [CityModel]) {
        if let bookmarksData = try? encoder.encode(bookmarks) {
            defaults.set(bookmarksData, forKey: bookmarksKey)
        }
    }
}
