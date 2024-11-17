//
//  Formatter+CustomTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class FormatterCustomTests: XCTestCase {
    
    func testFormattingPositiveInteger() {
        // Given
        let number = 1234567
        let expected = "1,234,567"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format positive integer.")
    }
    
    func testFormattingZero() {
        // Given
        let number = 0
        let expected = "0"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format zero.")
    }
    
    func testFormattingLargeInteger() {
        // Given
        let number = 9876543210
        let expected = "9,876,543,210"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format large integer.")
    }
    
    func testFormattingNegativeInteger() {
        // Given
        let number = -1234567
        let expected = "-1,234,567"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format negative integer.")
    }
    
    func testFormattingDecimalNumber() {
        // Given
        let number = 1234567.89
        let expected = "1,234,567,89"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format decimal number.")
    }
    
    func testFormattingIntMax() {
        // Given
        let number = Int.max
        let expected = "9,223,372,036,854,775,807"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format Int.max.")
    }

    func testFormattingIntMin() {
        // Given
        let number = Int.min
        let expected = "-9,223,372,036,854,775,808"

        // When
        let formattedString = Formatter.withSeparator.string(from: NSNumber(value: number))

        // Then
        XCTAssertEqual(formattedString, expected, "Failed to format Int.min.")
    }
    
}
