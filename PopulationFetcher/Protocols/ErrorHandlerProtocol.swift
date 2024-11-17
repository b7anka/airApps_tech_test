//
//  ErrorHandlerProtocol.swift
//  PopulationFetcher
//
//  Created by João Moreira on 17/11/2024.
//

import Foundation

protocol ErrorHandlerProtocol: AnyObject {
    // Method that takes an error and returns a user-friendly error message as a string.
    func handleError(_ error: Error) -> String
}
