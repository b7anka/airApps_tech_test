//
//  NationFilterTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class NationFilterTests: XCTestCase {
    
    var sut: NationFilter!
    var mockData: [PopulationInformation]!
    
    override func setUp() {
        super.setUp()
        sut = NationFilter()
        mockData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: "USA", state: "California", year: "2020", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: "USA", state: "Texas", year: "2020", population: 28995881),
            PopulationInformation(nationID: nil, stateID: nil, nation: "Canada", state: "Ontario", year: "2020", population: 14734014),
            PopulationInformation(nationID: nil, stateID: nil, nation: "Canada", state: "Quebec", year: "2020", population: 8537674),
            PopulationInformation(nationID: nil, stateID: nil, nation: "Australia", state: "New South Wales", year: "2020", population: 8166208),
            PopulationInformation(nationID: nil, stateID: nil, nation: "Unknown", state: nil, year: "2020", population: 1000000),
            PopulationInformation(nationID: nil, stateID: nil, nation: nil, state: "Bavaria", year: "2020", population: 13076721)
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
    
    func testFilterWithMatchingSearchTextReturnsMatchingNations() {
        // Given
        let searchText = "Canada"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 2, "Filter should return two matching nations.")
        XCTAssertTrue(filteredData.allSatisfy { $0.nation == "Canada" }, "All filtered entries should have nation 'Canada'.")
    }
    
    func testFilterWithNonMatchingSearchTextReturnsEmptyArray() {
        // Given
        let searchText = "Germany"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertTrue(filteredData.isEmpty, "Filter should return an empty array when no nations match the searchText.")
    }
    
    func testFilterIsCaseInsensitive() {
        // Given
        let searchText = "UsA"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 2, "Filter should be case-insensitive and return one matching nation.")
        XCTAssertEqual(filteredData.first?.nation, "USA", "Filter should return 'USA' as the matching nation.")
    }
    
    func testFilterWithNilNationDoesNotCrashAndExcludesNilNations() {
        // Given
        let searchText = "Australia"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 1, "Filter should return one matching nation.")
        XCTAssertEqual(filteredData.first?.nation, "Australia", "Filter should return 'Australia' as the matching nation.")
        XCTAssertFalse(filteredData.contains { $0.nation == nil }, "Filter should exclude entries with nil nation.")
    }
    
    func testFilterWithMultipleMatchingSearchTextReturnsAllMatchingNations() {
        // Given
        let searchText = "USA"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 2, "Filter should return two matching nations.")
        XCTAssertTrue(filteredData.allSatisfy { $0.nation == "USA" }, "All filtered entries should have nation 'USA'.")
    }
    
    func testFilterWithWhitespaceInSearchTextReturnsMatchingNations() {
        // Given
        let searchText = " Canada "
        
        // When
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        let filteredData = sut.filter(data: mockData, searchText: trimmedSearchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 2, "Filter should trim whitespace and return two matching nations.")
        XCTAssertTrue(filteredData.allSatisfy { $0.nation == "Canada" }, "All filtered entries should have nation 'Canada'.")
    }
    
    func testFilterWithSpecialCharactersInSearchTextReturnsMatchingNations() {
        // Given
        let searchText = "Austra!a"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertTrue(filteredData.isEmpty, "Filter should return an empty array when searchText contains special characters that don't match any nation.")
    }
    
    func testFilterWithEmptySearchTextIncludesAllNationsIncludingNil() {
        // Given
        let searchText = ""
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, mockData.count, "Filter should return all data when searchText is empty, including entries with nil nation.")
    }
    
    func testFilterWithSearchTextNotEmptyExcludesNilNations() {
        // Given
        let searchText = "Unknown"
        
        // When
        let filteredData = sut.filter(data: mockData, searchText: searchText)
        
        // Then
        XCTAssertEqual(filteredData.count, 1, "Filter should return one matching nation.")
        XCTAssertEqual(filteredData.first?.nation, "Unknown", "Filter should return 'Unknown' as the matching nation.")
        XCTAssertFalse(filteredData.contains { $0.nation == nil }, "Filter should exclude entries with nil nation.")
    }
    
}
