//
//  MenuPickerViewTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import PopulationFetcher

final class MenuPickerViewTests: XCTestCase {
    
    func testPickerDisplaysCorrectNumberOfOptions() throws {
        // Given
        let values = ["Option 1", "Option 2", "Option 3"]
        let binding = Binding<String>(wrappedValue: values[0])
        let view = MenuPickerView(selected: binding, title: "Test Picker", values: values)
        
        // When
        let picker = try view.inspect().find(ViewType.Picker.self)
        var texts = picker.findAll(ViewType.Text.self)
        texts.removeLast()
        
        // Then
        XCTAssertEqual(texts.count, values.count)
        for (index, text) in texts.enumerated() {
            XCTAssertEqual(try text.string(), values[index])
        }
    }
    
    func testPickerInitialSelectionBinding() {
        // Given
        let values = ["Option 1", "Option 2", "Option 3"]
        let initialSelection = "Option 2"
        let binding = Binding<String>(wrappedValue: initialSelection)
        _ = MenuPickerView(selected: binding, title: "Test Picker", values: values)
        
        // Then
        XCTAssertEqual(binding.wrappedValue, initialSelection)
    }
    
    func testPickerSelectionUpdatesBinding() throws {
        // Given
        let values = ["Option 1", "Option 2", "Option 3"]
        let binding = Binding<String>(wrappedValue: values[0])
        let view = MenuPickerView(selected: binding, title: "Test Picker", values: values)
        
        // When
        let picker = try view.inspect().find(ViewType.Picker.self)
        try picker.select(value: values[2])
        
        // Then
        XCTAssertEqual(binding.wrappedValue, values[2])
    }
    
}
