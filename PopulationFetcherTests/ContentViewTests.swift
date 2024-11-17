//
//  ContentViewTests.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import PopulationFetcher

final class ContentViewTests: XCTestCase {
    
    var viewModel: PopulationViewModel!
    var sut: ContentView!
    
    override func setUpWithError() throws {
        viewModel = PopulationViewModel()
        sut = ContentView(viewModel: self.viewModel)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
    
    func testNavigationViewExistsAndIsBound() throws {
        let view = try sut.inspect()
        
        XCTAssertNoThrow(try view.find(viewWithId: "navigationView"))
    }
    
    func testVStackExistsAndIsBound() throws {
        let view = try sut.inspect()
        
        XCTAssertNoThrow(try view.find(viewWithId: "vstack"))
    }

    func testDataTypePickerViewExistsAndIsBound() throws {
        let pickerView = try sut.inspect().find(DataTypePickerView.self)
        XCTAssertNoThrow(try pickerView.find(DataTypePickerView.self))
        
        XCTAssertEqual(viewModel.type, .state)
        viewModel.type = .nation
        XCTAssertEqual(viewModel.type, .nation)
    }
    
    func testMenuPickerViewShowsWhenAvailableYearsIsNonEmpty() throws {
        XCTAssertThrowsError(try sut.inspect().find(MenuPickerView<String>.self))
        
        viewModel.availableYears = ["2020", "2021"]
        
        let menuPickerView = try sut.inspect().find(MenuPickerView<String>.self)
        XCTAssertEqual(viewModel.availableYears, ["2020", "2021"])
        XCTAssertNoThrow(menuPickerView)
    }
    
    func testPopulationListViewExistsAndIsBound() throws {
        let populationListView = try sut.inspect().find(PopulationListView.self)
        
        XCTAssertNoThrow(populationListView)
    }
    
}

