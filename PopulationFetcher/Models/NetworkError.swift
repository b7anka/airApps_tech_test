//
//  NetworkError.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

enum NetworkError: LocalizedError {
    // Enum cases representing different types of network errors.
    case invalidURL // Error case for an invalid URL.
    case invalidResponse // Error case for an invalid response from the server.
    case noData // Error case for when no data is received from the server.
    case decodingError // Error case for a failure in decoding the received data.
    
    // Provides a user-friendly error description for each error case, conforming to LocalizedError.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL." // Description for invalid URL error.
        case .invalidResponse:
            return "Invalid response from the server." // Description for invalid server response.
        case .noData:
            return "No data received." // Description for no data received error.
        case .decodingError:
            return "Failed to decode the data." // Description for data decoding failure.
        }
    }
}

