//
//  DetailsViewModelTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class DetailsViewModelTests: XCTestCase {
    
    func testInitializationWithStateData() {
        // Given
        let data = PopulationInformation(
            nationID: "1",
            stateID: "NY",
            nation: "USA",
            state: "New York",
            year: "2020",
            population: 10000000
        )
        let type: DataType = .state

        // When
        let viewModel = DetailsViewModel(data: data, type: type)

        // Then
        XCTAssertEqual(viewModel.title, "New York")
        XCTAssertEqual(viewModel.id, "NY")
        XCTAssertEqual(viewModel.year, "2020")
        XCTAssertEqual(viewModel.population, "10,000,000")
        XCTAssertEqual(viewModel.additionalInfo.count, 2)
        XCTAssertEqual(viewModel.additionalInfo[0].title, "Nation")
        XCTAssertEqual(viewModel.additionalInfo[0].value, "USA")
        XCTAssertEqual(viewModel.additionalInfo[1].title, "State")
        XCTAssertEqual(viewModel.additionalInfo[1].value, "New York")
    }

    func testInitializationWithNationData() {
        // Given
        let data = PopulationInformation(
            nationID: "1",
            stateID: nil,
            nation: "USA",
            state: nil,
            year: "2020",
            population: 331000000
        )
        let type: DataType = .nation

        // When
        let viewModel = DetailsViewModel(data: data, type: type)

        // Then
        XCTAssertEqual(viewModel.title, "USA")
        XCTAssertEqual(viewModel.id, "1")
        XCTAssertEqual(viewModel.year, "2020")
        XCTAssertEqual(viewModel.population, "331,000,000")
        XCTAssertEqual(viewModel.additionalInfo.count, 1)
        XCTAssertEqual(viewModel.additionalInfo[0].title, "Nation")
        XCTAssertEqual(viewModel.additionalInfo[0].value, "USA")
    }

    func testInitializationWithMissingData() {
        // Given
        let data = PopulationInformation(
            nationID: nil,
            stateID: nil,
            nation: nil,
            state: nil,
            year: nil,
            population: nil
        )
        let type: DataType = .state

        // When
        let viewModel = DetailsViewModel(data: data, type: type)

        // Then
        XCTAssertEqual(viewModel.title, "Unknown State")
        XCTAssertEqual(viewModel.id, "Unknown ID")
        XCTAssertEqual(viewModel.year, "Unknown Year")
        XCTAssertEqual(viewModel.population, "Unknown Population")
        XCTAssertTrue(viewModel.additionalInfo.isEmpty)
    }
}

