//
//  UInt+CustomTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class UIntCustomTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Formatter.withSeparator.numberStyle = .decimal
        Formatter.withSeparator.groupingSeparator = ","
    }
    
    func testLargeNumberFormatting() {
        // Given
        let number: UInt = 1_234_567_890
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let expected = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        
        // When
        let result = number.formattedWithSeparator
        
        // Then
        XCTAssertEqual(result, expected, "Large number formatting failed")
    }
    
    func testZeroFormatting() {
        // Given
        let number: UInt = 0
        
        // Expected result
        let expected = "0"
        
        // When
        let result = number.formattedWithSeparator
        
        // Then
        XCTAssertEqual(result, expected, "Zero formatting failed")
    }
    
    func testSmallNumberFormatting() {
        // Given
        let number: UInt = 123
        
        // Expected result
        let expected = "123"
        
        // When
        let result = number.formattedWithSeparator
        
        // Then
        XCTAssertEqual(result, expected, "Small number formatting failed")
    }
    
    func testMaximumUIntValueFormatting() {
        // Given
        let number: UInt = UInt.max
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let expected = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        
        // When
        let result = number.formattedWithSeparator
        
        // Then
        XCTAssertEqual(result, expected, "Maximum UInt value formatting failed")
    }
    
    func testFallbackFormattingOnFailure() {
        // Given
        let number: UInt = 1234567890
        
        Formatter.withSeparator.numberStyle = .none
        
        let expected = "\(number)"
        
        // When
        let result = number.formattedWithSeparator
        
        // Then
        XCTAssertEqual(result, expected, "Fallback formatting failed when formatter returns nil")
    }
    
}
