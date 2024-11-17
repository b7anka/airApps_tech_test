//
//  DefaulterrorHandlerTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class DefaultErrorHandlerTests: XCTestCase {
    
    var sut: DefaultErrorHandler!
    
    override func setUp() {
        super.setUp()
        sut = DefaultErrorHandler()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testHandleErrorWithURLErrorNotConnectedToInternetReturnsAppropriateMessage() {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        let expectedMessage = "No internet connection. Please check your network settings."
        
        // When
        let message = sut.handleError(urlError)
        
        // Then
        XCTAssertEqual(message, expectedMessage, "Should return appropriate message for notConnectedToInternet.")
    }
    
    func testHandleErrorWithURLErrorTimedOutReturnsAppropriateMessage() {
        // Given
        let urlError = URLError(.timedOut)
        let expectedMessage = "The request timed out. Please try again."
        
        // When
        let message = sut.handleError(urlError)
        
        // Then
        XCTAssertEqual(message, expectedMessage, "Should return appropriate message for timedOut.")
    }
    
    func testHandleErrorWithURLErrorOtherReturnsDefaultMessage() {
        // Given
        let urlError = URLError(.cannotFindHost)
        let expectedMessage = "Unable to fetch data. Please check your internet connection."
        
        // When
        let message = sut.handleError(urlError)
        
        // Then
        XCTAssertEqual(message, expectedMessage, "Should return default message for other URLError cases.")
    }
    
    func testHandleErrorWithDecodingErrorReturnsAppropriateMessage() {
        // Given
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Data corrupted"))
        let expectedMessage = "An error occurred while processing data."
        
        // When
        let message = sut.handleError(decodingError)
        
        // Then
        XCTAssertEqual(message, expectedMessage, "Should return appropriate message for DecodingError.")
    }
    
    func testHandleErrorWithNetworkErrorInvalidResponseReturnsAppropriateMessage() {
        // Given
        let networkError = NetworkError.invalidResponse
        let expectedMessage = "Invalid response from the server."
        
        // When
        let message = sut.handleError(networkError)
        
        // Then
        XCTAssertEqual(message, expectedMessage, "Should return appropriate message for NetworkError.invalidResponse.")
    }
    
    func testHandleErrorWithUnknownErrorReturnsLocalizedDescription() {
        // Given
        let unknownError = NSError(domain: "com.example.error", code: 999, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred."])
        let expectedMessage = "An unknown error occurred."
        
        // When
        let message = sut.handleError(unknownError)
        
        // Then
        XCTAssertEqual(message, expectedMessage, "Should return localizedDescription for unknown Error types.")
    }
    
}
