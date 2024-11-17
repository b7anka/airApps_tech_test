//
//  StateFilterTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class StateFilterTests: XCTestCase {
    
    var sut: StateFilter!
    var mockData: [PopulationInformation]!
    
    override func setUp() {
        super.setUp()
        sut = StateFilter()
        mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "California", year: "2020", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Texas", year: "2020", population: 28995881),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "New York", year: "2020", population: 19453561),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Florida", year: "2020", population: 21477737),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: nil, year: "2020", population: 1000000)
        ]
    }
    
    override func tearDown() {
        sut = nil
        mockData = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testFilterWithEmptySearchTextReturnsAllData() {
        // Given
        let searchText = ""
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, mockData.count, "Filter should return all data when searchText is empty.")
    }
    
    func testFilterWithMatchingSearchTextReturnsMatchingStates() {
        // Given
        let searchText = "New"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 1, "Filter should return one matching state.")
        XCTAssertEqual(filteredData.first?.state, "New York", "Filter should return 'New York' as the matching state.")
    }
    
    func testFilterWithNonMatchingSearchTextReturnsEmptyArray() {
        // Given
        let searchText = "Alaska"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertTrue(filteredData.isEmpty, "Filter should return an empty array when no states match the searchText.")
    }
    
    func testFilterIsCaseInsensitive() {
        // Given
        let searchText = "california"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 1, "Filter should be case-insensitive and return one matching state.")
        XCTAssertEqual(filteredData.first?.state, "California", "Filter should return 'California' as the matching state.")
    }
    
    func testFilterWithNilStateDoesNotCrashAndExcludesNilStates() {
        // Given
        let searchText = "a"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 3, "Filter should exclude entries with nil state and return only matching states.")
        XCTAssertFalse(filteredData.contains { $0.state == nil }, "Filter should not include entries with nil state.")
    }
    
    func testFilterWithMultipleMatchingSearchTextReturnsAllMatchingStates() {
        // Given
        let searchText = "a" // Matches "California", "Texas", and "Florida"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 3, "Filter should return all states containing 'a'.")
        let expectedStates = ["California", "Texas", "Florida"]
        let resultStates = filteredData.compactMap { $0.state }
        XCTAssertTrue(resultStates.allSatisfy { expectedStates.contains($0) }, "Filter should return the correct matching states.")
    }
    
    func testFilterWithWhitespaceInSearchTextReturnsMatchingStates() {
        // Given
        let searchText = "New "
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 1, "Filter should trim whitespace and return one matching state.")
        XCTAssertEqual(filteredData.first?.state, "New York", "Filter should return 'New York' as the matching state.")
    }
    
    func testFilterWithSpecialCharactersInSearchTextReturnsMatchingStates() {
        // Given
        let searchText = "York"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 1, "Filter should return one matching state with special characters.")
        XCTAssertEqual(filteredData.first?.state, "New York", "Filter should return 'New York' as the matching state.")
    }
    
    func testFilterWithEmptySearchTextExcludesNilStates() {
        // Given
        let searchText = ""
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, mockData.count, "Filter should return all data when searchText is empty, including entries with nil state.")
        
    }
    
}
