//
//  DefaultDataFilterFactoryTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class DefaultDataFilterFactoryTests: XCTestCase {
    
    var sut: DefaultDataFilterFactory!
    
    override func setUp() {
        super.setUp()
        sut = DefaultDataFilterFactory()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCreateFilterForStateReturnsStateFilter() {
        // Given
        let dataType: DataType = .state
        
        // When
        let filter = sut.createFilter(for: dataType)
        
        // Then
        XCTAssertTrue(filter is StateFilter, "Factory should return StateFilter for DataType.state")
    }
    
    func testCreateFilterForNationReturnsNationFilter() {
        // Given
        let dataType: DataType = .nation
        
        // When
        let filter = sut.createFilter(for: dataType)
        
        // Then
        XCTAssertTrue(filter is NationFilter, "Factory should return NationFilter for DataType.nation")
    }
    
    func testCreateFilterDifferentDataTypesReturnDifferentInstances() {
        // Given
        let stateDataType: DataType = .state
        let nationDataType: DataType = .nation
        
        // When
        let stateFilter = sut.createFilter(for: stateDataType)
        let nationFilter = sut.createFilter(for: nationDataType)
        
        // Then
        XCTAssertTrue(stateFilter is StateFilter, "Factory should return StateFilter for DataType.state")
        XCTAssertTrue(nationFilter is NationFilter, "Factory should return NationFilter for DataType.nation")
        XCTAssertFalse(stateFilter === nationFilter, "Factory should return different instances for different DataTypes")
    }
    
    func testCreateFilterConsistencyReturnsSameType() {
        // Given
        let dataType: DataType = .state
        
        // When
        let filter1 = sut.createFilter(for: dataType)
        let filter2 = sut.createFilter(for: dataType)
        
        // Then
        XCTAssertTrue(filter1 is StateFilter, "First filter should be StateFilter for DataType.state")
        XCTAssertTrue(filter2 is StateFilter, "Second filter should be StateFilter for DataType.state")
    }
    
}

