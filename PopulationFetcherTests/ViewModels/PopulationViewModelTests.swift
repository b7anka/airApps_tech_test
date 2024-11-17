//
//  PopulationViewModelTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
import Combine
@testable import PopulationFetcher

final class PopulationViewModelTests: XCTestCase {

    func testSuccessfulDataFetch() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "California", year: "2020", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Texas", year: "2020", population: 28995881)
        ]

        // When
        sut.fetchPopulationData()
        await fakeAwait()
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.availableYears, ["2020"])
        XCTAssertEqual(sut.filteredData.count, 2)
        XCTAssertEqual(sut.filteredData.map { $0.state }, ["California", "Texas"])
    }
    
    func testDataFetchWithError() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        networkService.mockError = URLError(.notConnectedToInternet)

        // When
        sut.fetchPopulationData()
        await fakeAwait()
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Mock error message")
        XCTAssertTrue(sut.filteredData.isEmpty)
    }

    func testFilteringDataBySearchText() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "California", year: "2020", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Texas", year: "2020", population: 28995881),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "New York", year: "2020", population: 19453561)
        ]
        sut.fetchPopulationData()
        await fakeAwait()
        // When
        sut.searchText = "New"

        // Wait for debouncing
        try? await Task.sleep(nanoseconds: 800_000_000) // 800 milliseconds

        // Then
        XCTAssertEqual(sut.filteredData.count, 1)
        XCTAssertEqual(sut.filteredData.first?.state, "New York")
        XCTAssertFalse(sut.isNoSearchResults)
    }

    func testDebouncedSearchTextUpdates() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "California", year: "2020", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Texas", year: "2020", population: 28995881),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "New York", year: "2020", population: 19453561)
        ]
        sut.fetchPopulationData()
        await fakeAwait()
        // When
        sut.searchText = "Cal"
        sut.searchText = "Cali"
        sut.searchText = "Calif"

        // Wait for debouncing
        try? await Task.sleep(nanoseconds: 800_000_000) // 800 milliseconds

        // Then
        XCTAssertEqual(sut.filteredData.count, 1)
        XCTAssertEqual(sut.filteredData.first?.state, "California")
    }

    func testChangingDataType() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: "USA", state: nil, year: "2020", population: 331002651)
        ]

        // When
        sut.type = .nation
        sut.fetchPopulationData()
        await fakeAwait()

        // Then
        XCTAssertEqual(sut.filteredData.count, 1)
        XCTAssertEqual(sut.filteredData.first?.nation, "USA")
    }

    func testNoDataAvailable() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = []

        // When
        sut.fetchPopulationData()
        await fakeAwait()

        // Then
        XCTAssertEqual(sut.errorMessage, "No data available for the selected type.")
        XCTAssertTrue(sut.filteredData.isEmpty)
        XCTAssertTrue(sut.availableYears.isEmpty)
    }

    func testTaskCancellation() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "California", year: "2020", population: 39512223)
        ]
        networkService.delay = 1_000_000_000

        // When
        sut.fetchPopulationData()
        sut.cancelFetchOperation()
        // Wait for the task cancellation
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.filteredData.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func testSelectedYearChange() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "California", year: "2019", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Texas", year: "2020", population: 28995881)
        ]
        sut.fetchPopulationData()
        await fakeAwait()
        // When
        sut.selectedYear = "2019"

        // Then
        XCTAssertEqual(sut.filteredData.count, 1)
        XCTAssertEqual(sut.filteredData.first?.state, "California")
    }
    
    func testIsNoSearchResultsFlag() async {
        // Given
        let components = makeSut()
        let networkService = components.networkService
        let sut = components.sut
        
        networkService.mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Texas", year: "2020", population: 28995881)
        ]
        sut.fetchPopulationData()
        // When
        sut.searchText = "Nonexistent"

        try? await Task.sleep(nanoseconds: 800_000_000)

        // Then
        XCTAssertTrue(sut.isNoSearchResults)
        XCTAssertTrue(sut.filteredData.isEmpty)
    }
    
    private func fakeAwait() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
    
    private func makeSut() -> (networkService: MockNetworkService, dataFilterFactory: MockDataFilterFactory, errorHandler: MockErrorHandler, sut: PopulationViewModel) {
        
        let networkService: MockNetworkService = MockNetworkService()
        let dataFilterFactory: MockDataFilterFactory = MockDataFilterFactory()
        let errorHandler: MockErrorHandler = MockErrorHandler()
        let sut: PopulationViewModel = PopulationViewModel(networkService: networkService, dataFilterFactory: dataFilterFactory, errorHandler: errorHandler)
        
        trackForMemoryLeak(instance: sut)
        trackForMemoryLeak(instance: networkService)
        trackForMemoryLeak(instance: dataFilterFactory)
        trackForMemoryLeak(instance: errorHandler)
        
        return (networkService, dataFilterFactory, errorHandler, sut)
        
    }
    
}
