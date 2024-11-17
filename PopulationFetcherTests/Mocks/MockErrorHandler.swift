//
//  MockErrorHandler.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class MockErrorHandler: ErrorHandlerProtocol {
    func handleError(_ error: Error) -> String {
        return "Mock error message"
    }
}
