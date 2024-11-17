//
//  DefaultErrorHandler.swift
//  PopulationFetcher
//
//  Created by João Moreira on 17/11/2024.
//

import Foundation

final class DefaultErrorHandler: ErrorHandlerProtocol {
    
    // Main error handling function that takes an error and returns a user-friendly message.
    func handleError(_ error: Error) -> String {
        // Checks if the error is a URLError and, if so, handles it with handleURLError.
        if let urlError = error as? URLError {
            return handleURLError(urlError)
        // Checks if the error is a DecodingError and, if so, handles it with handleDecodingError.
        } else if let decodingError = error as? DecodingError {
            return handleDecodingError(decodingError)
        // Checks if the error is a NetworkError (custom error type) and, if so, handles it with handleNetworkError.
        } else if let networkError = error as? NetworkError {
            return handleNetworkError(networkError)
        // For all other error types, return the default localized description.
        } else {
            return error.localizedDescription
        }
    }
    
    // Handles custom NetworkError types by returning their localized descriptions.
    private func handleNetworkError(_ error: NetworkError) -> String {
        return error.localizedDescription
    }

    // Handles URLError, mapping specific URL error codes to custom error messages.
    private func handleURLError(_ error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet:
            return "No internet connection. Please check your network settings."
        case .timedOut:
            return "The request timed out. Please try again."
        default:
            return "Unable to fetch data. Please check your internet connection."
        }
    }

    // Provides a generic error message for DecodingError types.
    private func handleDecodingError(_ error: DecodingError) -> String {
        return "An error occurred while processing data."
    }
}

