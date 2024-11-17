//
//  DataTypePickerViewTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import PopulationFetcher

final class DataTypePickerViewTests: XCTestCase {

    func testPickerDisplaysCorrectOptions() throws {
        // Given
        let binding = Binding<DataType>(wrappedValue: .state)
        let view = DataTypePickerView(type: binding)

        // When
        let picker = try view.inspect().picker()
        var texts = picker.findAll(ViewType.Text.self)
        texts.removeLast()

        // Then
        XCTAssertEqual(texts.count, 2)
        XCTAssertEqual(try texts[0].string(), "Nation")
        XCTAssertEqual(try texts[1].string(), "State")
    }

    func testPickerInitialSelection() {
        // Given
        let binding = Binding<DataType>(wrappedValue: .nation)

        // Then
        XCTAssertEqual(binding.wrappedValue, .nation)
    }

    func testPickerSelectionUpdatesBinding() throws {
        // Given
        let binding = Binding<DataType>(wrappedValue: .state)
        let view = DataTypePickerView(type: binding)

        // When
        let picker = try view.inspect().picker()
        // Simulate selection change
        try picker.select(value: DataType.nation)

        // Then
        XCTAssertEqual(binding.wrappedValue, .nation)
    }
    
}


