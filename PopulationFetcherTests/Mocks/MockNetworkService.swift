//
//  MockNetworkService.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class MockNetworkService: NetworkServiceProtocol {
    
    var mockData: [PopulationInformation] = []
    var mockError: Error?
    var delay: UInt64 = 0
    
    func fetchPopulationData(type: DataType) async throws -> [PopulationInformation] {
        try await Task.sleep(nanoseconds: delay)
        try Task.checkCancellation()
        if let error = mockError {
            throw error
        }
        return mockData
    }
    
}

