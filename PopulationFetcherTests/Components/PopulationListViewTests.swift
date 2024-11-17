//
//  PopulationListViewTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
import ViewInspector
@testable import PopulationFetcher

final class PopulationListViewTests: XCTestCase {
    
    @MainActor func testLoadingStateDisplaysProgressView() throws {
        
        let viewModel = PopulationViewModel()
        viewModel.isLoading = true
        let view = PopulationListView(viewModel: viewModel)
        
        XCTAssertNoThrow(try view.inspect().find(viewWithId: "ProgressView"))
    }

    @MainActor func testErrorStateDisplaysErrorMessage() throws {
        // Given
        let viewModel = PopulationViewModel()
        viewModel.errorMessage = "An error occurred"
        let view = PopulationListView(viewModel: viewModel)
        
        // When
        let text = try view.inspect().find(text: "Error: An error occurred")
        
        // Then
        XCTAssertEqual(try text.string(), "Error: An error occurred")
    }
    
    @MainActor func testNoResultsStateDisplaysNoResultsMessage() throws {
        // Given
        let viewModel = PopulationViewModel()
        viewModel.searchText = "Test"
        viewModel.filteredData = []
        let view = PopulationListView(viewModel: viewModel)
        
        // When
        let text = try view.inspect().find(text: "No results found for search term: Test")
        
        // Then
        XCTAssertEqual(try text.string(), "No results found for search term: Test")
    }
    
    @MainActor func testDisplaysPopulationData() throws {
        // Given
        let data = PopulationInformation(
            nationID: nil, stateID: "1",
            nation: nil, state: "New York",
            year: "2020",
            population: 1000000
        )
        let viewModel = PopulationViewModel()
        viewModel.type = .state
        viewModel.filteredData = [data]
        let view = PopulationListView(viewModel: viewModel)
        
        // When
        let list = try view.inspect().find(ViewType.List.self)
        let cell = try list.find(ViewType.NavigationLink.self)
        let vstack = try cell.labelView().find(ViewType.VStack.self)
        let stateText = try vstack.find(text: "New York")
        let populationText = try vstack.find(text: "Population: 1,000,000")
        
        // Then
        XCTAssertEqual(try stateText.string(), "New York")
        XCTAssertEqual(try populationText.string(), "Population: 1,000,000")
    }
    
    @MainActor func testDisplaysUnknownPopulationWhenPopulationIsNil() throws {
        // Given
        let data = PopulationInformation(
            nationID: nil, stateID: "1",
            nation: nil, state: "Unknown State",
            year: "2020",
            population: nil
        )
        let viewModel = PopulationViewModel()
        viewModel.type = .state
        viewModel.filteredData = [data]
        let view = PopulationListView(viewModel: viewModel)
        
        // When
        let list = try view.inspect().find(ViewType.List.self)
        let cell = try list.find(ViewType.NavigationLink.self)
        let vstack = try cell.labelView().find(ViewType.VStack.self)
        let stateText = try vstack.find(text: "Unknown State")
        let populationText = try vstack.find(text: "Population: Unknown Population")
        
        // Then
        XCTAssertEqual(try stateText.string(), "Unknown State")
        XCTAssertEqual(try populationText.string(), "Population: Unknown Population")
    }

    @MainActor func testDisplaysMultipleDataItems() throws {
        // Given
        let data1 = PopulationInformation(
            nationID: nil, stateID: "1",
            nation: nil, state: "New York",
            year: "2020",
            population: 1000000
        )
        let data2 = PopulationInformation(
            nationID: nil, stateID: "2",
            nation: nil, state: "California",
            year: "2020",
            population: 2000000
        )
        let viewModel = PopulationViewModel()
        viewModel.type = .state
        viewModel.filteredData = [data1, data2]
        let view = PopulationListView(viewModel: viewModel)
        
        // When
        let list = try view.inspect().find(ViewType.List.self)
        let cells = list.findAll(ViewType.NavigationLink.self)
        
        // Then
        XCTAssertEqual(cells.count, 2)
        let firstCellVStack = try cells[0].labelView().find(ViewType.VStack.self)
        let firstStateText = try firstCellVStack.find(text: "New York")
        XCTAssertEqual(try firstStateText.string(), "New York")
        
        let secondCellVStack = try cells[1].labelView().find(ViewType.VStack.self)
        let secondStateText = try secondCellVStack.find(text: "California")
        XCTAssertEqual(try secondStateText.string(), "California")
    }

    @MainActor func testSearchFunctionalityFiltersData() async throws {
        // Given
        let data1 = PopulationInformation(
            nationID: nil, stateID: "1",
            nation: nil, state: "New York",
            year: "2020",
            population: 1000000
        )
        let data2 = PopulationInformation(
            nationID: nil, stateID: "2",
            nation: nil, state: "California",
            year: "2020",
            population: 2000000
        )
        let mockWebService = MockNetworkService()
        mockWebService.mockData = [data1, data2]
        let viewModel = PopulationViewModel(networkService: mockWebService)
        let view = PopulationListView(viewModel: viewModel)
        try await Task.sleep(nanoseconds: 500_000_000)
        viewModel.type = .state
        viewModel.selectedYear = "2020"
        
        // When
        viewModel.searchText = "New York"
        
        // Then
        let list = try view.inspect().find(ViewType.List.self)
        let cells = list.findAll(ViewType.NavigationLink.self)
        let cell = cells.first!
        let stateText = try cell.labelView().find(text: "New York")
        XCTAssertEqual(try stateText.string(), "New York")
    }
    
}
