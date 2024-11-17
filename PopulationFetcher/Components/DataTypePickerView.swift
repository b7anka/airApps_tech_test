//
//  DataTypePickerView.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import SwiftUI

struct DataTypePickerView: View {
    
    // Binding to the selected data type, allowing two-way data binding with the parent view.
    @Binding var type: DataType
    
    var body: some View {
        // Creates a picker to select a data type, with the label "Data Type".
        Picker("Data Type", selection: $type) {
            // Iterates over all cases of DataType to create segmented picker options.
            ForEach(DataType.allCases) { type in
                // Displays the raw value of each data type as the picker label.
                Text(type.rawValue).tag(type) // Sets the tag to the current type.
            }
        }
        .pickerStyle(SegmentedPickerStyle()) // Uses a segmented style for a compact, tab-like selection.
    }
}

