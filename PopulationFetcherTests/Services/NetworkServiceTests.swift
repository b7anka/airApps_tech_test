//
//  NetworkServiceTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class NetworkServiceTests: XCTestCase {
    
    var sut: NetworkService!
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        
        sut = NetworkService(session: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        urlSession = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchPopulationDataSuccessfulResponseReturnsData() async {
        // Given
        let expectedData = [
            PopulationInformation(nationID: nil, stateID: nil, nation: "USA", state: "California", year: "2020", population: 39512223),
            PopulationInformation(nationID: nil, stateID: nil, nation: "USA", state: "Texas", year: "2020", population: 28995881)
        ]
        
        let populationData = PopulationData(data: expectedData)
        let mockJSONData = try! JSONEncoder().encode(populationData)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://datausa.io/api/data?drilldowns=State&measures=Population")
            
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockJSONData)
        }
        
        // When
        do {
            let result = try await sut.fetchPopulationData(type: .state)
            
            // Then
            XCTAssertEqual(result.count, expectedData.count, "The fetched data should match the expected data.")
        } catch {
            XCTFail("Expected successful data fetch, but received error: \(error)")
        }
    }
    
    func testFetchPopulationDataInvalidURLThrowsInvalidURLError() async {
        
        sut = NetworkService(session: urlSession, urlString: nil)
        
        MockURLProtocol.requestHandler = { request in
            throw NetworkError.invalidURL
        }
        
        do {
            _ = try await sut.fetchPopulationData(type: .state)
            XCTFail("Should fail since url is invalid")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Expected NetworkError.invalidUrl, but received different error: \(error)")
        }
        
    }
    
    func testFetchPopulationDataNon2xxResponseThrowsInvalidResponseError() async {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)!
            let data = Data()
            return (response, data)
        }
        
        // When
        do {
            _ = try await sut.fetchPopulationData(type: .state)
            XCTFail("Expected NetworkError.invalidResponse to be thrown, but no error was thrown.")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .invalidResponse, "Should throw NetworkError.invalidResponse for non-2xx responses.")
        } catch {
            XCTFail("Expected NetworkError.invalidResponse, but received different error: \(error)")
        }
    }
    
    func testFetchPopulationDataDecodingErrorThrowsDecodingError() async {
        // Given
        let invalidJSONData = Data("invalid_json".utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, invalidJSONData)
        }
        
        // When
        do {
            _ = try await sut.fetchPopulationData(type: .state)
            XCTFail("Expected DecodingError to be thrown, but no error was thrown.")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError, "Received expected DecodingError.")
        }
    }
    
}

