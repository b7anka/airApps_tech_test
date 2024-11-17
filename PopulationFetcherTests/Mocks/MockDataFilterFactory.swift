//
//  MockDataFilterFactory.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class MockDataFilterFactory: DataFilterFactoryProtocol {
    func createFilter(for dataType: DataType) -> DataFilterProtocol {
        return MockDataFilter(dataType: dataType)
    }
}
