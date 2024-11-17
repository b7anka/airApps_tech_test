//
//  MenuPickerView.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import SwiftUI

struct MenuPickerView<T: Hashable & CustomStringConvertible>: View {
    
    // Binding to the selected value, allowing two-way data binding with the parent view.
    @Binding var selected: T
    
    // Title to display above the picker, providing context to the user.
    let title: String
    
    // Array of values that will populate the picker options.
    let values: [T]
    
    var body: some View {
        // Creates a Picker view with a menu style, displaying the title above the picker.
        Picker(title, selection: $selected) {
            // Iterates over each value in the `values` array to create a menu item.
            ForEach(values, id: \.self) { value in
                // Displays each value's description as the text label for the picker item.
                Text(value.description)
                    .tag(value) // Sets the tag to the value itself, enabling selection by value.
            }
        }
        .pickerStyle(MenuPickerStyle()) // Sets the picker style to a menu, suitable for compact display.
    }
}


