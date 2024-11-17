//
//  DetailsViewTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
import ViewInspector
@testable import PopulationFetcher

final class DetailsViewTests: XCTestCase {
    
    func testDetailsViewDisplaysStateData() throws {
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
        let viewModel = DetailsViewModel(data: data, type: type)
        let view = DetailsView(data: data, type: type)

        // When
        let titleText = try view.inspect().find(text: viewModel.title)
        let idText = try view.inspect().find(text: viewModel.id)
        let yearText = try view.inspect().find(text: "Year: \(viewModel.year)")
        let populationText = try view.inspect().find(text: "Population: \(viewModel.population)")
        let nationText = try view.inspect().find(text: "Nation: USA")
        let stateText = try view.inspect().find(text: "State: New York")

        // Then
        XCTAssertEqual(try titleText.string(), "New York")
        XCTAssertEqual(try idText.string(), "NY")
        XCTAssertEqual(try yearText.string(), "Year: 2020")
        XCTAssertEqual(try populationText.string(), "Population: 10,000,000")
        XCTAssertEqual(try nationText.string(), "Nation: USA")
        XCTAssertEqual(try stateText.string(), "State: New York")
    }

    func testDetailsViewDisplaysNationData() throws {
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
        let viewModel = DetailsViewModel(data: data, type: type)
        let view = DetailsView(data: data, type: type)

        // When
        let titleText = try view.inspect().find(text: viewModel.title)
        let idText = try view.inspect().find(text: viewModel.id)
        let yearText = try view.inspect().find(text: "Year: \(viewModel.year)")
        let populationText = try view.inspect().find(text: "Population: \(viewModel.population)")
        let nationText = try view.inspect().find(text: "Nation: USA")
        let stateTextCount = try view.inspect().findAll(ViewType.Text.self, where: { (text) -> Bool in
            try text.string().contains("State:")
        }).count

        // Then
        XCTAssertEqual(try titleText.string(), "USA")
        XCTAssertEqual(try idText.string(), "1")
        XCTAssertEqual(try yearText.string(), "Year: 2020")
        XCTAssertEqual(try populationText.string(), "Population: 331,000,000")
        XCTAssertEqual(try nationText.string(), "Nation: USA")
        XCTAssertEqual(stateTextCount, 0)
    }

    func testDetailsViewDisplaysUnknownsWhenDataMissing() throws {
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
        let viewModel = DetailsViewModel(data: data, type: type)
        let view = DetailsView(data: data, type: type)

        // When
        let titleText = try view.inspect().find(text: viewModel.title)
        let idText = try view.inspect().find(text: viewModel.id)
        let yearText = try view.inspect().find(text: "Year: \(viewModel.year)")
        let populationText = try view.inspect().find(text: "Population: \(viewModel.population)")
        let additionalInfoCount = viewModel.additionalInfo.count

        // Then
        XCTAssertEqual(try titleText.string(), "Unknown State")
        XCTAssertEqual(try idText.string(), "Unknown ID")
        XCTAssertEqual(try yearText.string(), "Year: Unknown Year")
        XCTAssertEqual(try populationText.string(), "Population: Unknown Population")
        XCTAssertEqual(additionalInfoCount, 0)
    }
}

