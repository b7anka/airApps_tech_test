//
//  NetworkService.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    // Dependencies
    private let session: URLSession // URLSession instance used for making network requests.
    private let urlString: String? // Base URL string, with a placeholder to be replaced by specific data types.
    
    // Initializer with default values for session and urlString, allowing dependency injection for testing.
    init(session: URLSession = .shared, urlString: String? = apiUrl) {
        self.session = session
        self.urlString = urlString
    }
    
    // Fetches population data asynchronously for a specific data type (state or nation).
    func fetchPopulationData(type: DataType) async throws -> [PopulationInformation] {
        // Replaces placeholder "XX" in the URL string with the actual type and creates a URL.
        guard let urlString,
              let url = URL(string: urlString.replacingOccurrences(of: "XX", with: "\(type.rawValue)")) else {
            throw NetworkError.invalidURL // Throws if URL construction fails.
        }

        // Performs the network request with async/await, capturing data and response.
        let (data, response) = try await session.data(from: url)

        // Validates the HTTP response status code, expecting it to be in the 200-299 range.
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse // Throws an error for non-2xx responses.
        }

        // Decodes the JSON response data into PopulationData and returns its data property.
        let decoder = JSONDecoder()
        let populationResponse = try decoder.decode(PopulationData.self, from: data)
        return populationResponse.data ?? [] // Returns decoded data or an empty array if nil.
    }
    
}

