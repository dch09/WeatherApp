//
//  NetworkingClient.swift
//  WeatherApp
//
//  Created by Daniel Choroszucha on 18/02/2023.
//

import Alamofire
import Foundation

class NetworkingClient {
    static var accuWeatherKey = "vvEssrYWZ2znsmodnXjBe3JWVlAECS1K"
    static var openWeatherKey = "178cf2d3e4d3c196ab2981c17820fa1d"
    static var shared = NetworkingClient()

    /// May not work correctly due to 50 calls a day API limit.
    func search(for query: String, completion: @escaping (Result<[AutocompleteResponse], AFError>) -> Void) {
        AF.request(AutocompleteEndpoint.url,
                   parameters: AutocompleteEndpoint.parameters(for: query))
            .validate()
            .responseDecodable(of: [AutocompleteResponse].self) { response in
                completion(response.result)
            }
    }

    func getCoordinates(for city: String, completion: @escaping (Result<[GeocodingResponse], AFError>) -> Void) {
        AF.request(GeocodingEndpoint.url,
                   parameters: GeocodingEndpoint.parameters(city: city))
            .validate()
            .responseDecodable { response in
                completion(response.result)
            }
    }

    func fetchWeather(for coordinates: Coordinates,
                      completion: @escaping (Result<CurrentWeatherResponse, AFError>) -> Void) {
        AF.request(WeatherDataEndpoint.url,
                   parameters: WeatherDataEndpoint.parameters(coordinates: coordinates))
            .validate()
            .responseDecodable { response in
                completion(response.result)
            }
    }
}

extension NetworkingClient {
    struct Coordinates {
        let latitude: Double
        let longitude: Double
    }
}
