//
//  ContentView.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import SwiftUI

struct ContentView: View {
    
    // View model that manages the population data and UI states for this view.
    @StateObject var viewModel = PopulationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) { // Arranges elements vertically with no additional spacing between them.
                
                // Data type picker allows the user to select between types (e.g., state or nation).
                DataTypePickerView(type: $viewModel.type)
                    .padding() // Adds padding around the picker for better spacing.
                
                // Year picker displayed only if there are available years in the view model.
                if !viewModel.availableYears.isEmpty {
                    MenuPickerView<String>(
                        selected: $viewModel.selectedYear, // Binds selected year to the view model.
                        title: "Year", // Title displayed above the picker.
                        values: viewModel.availableYears // Populates picker with available years from the view model.
                    )
                    .padding() // Adds padding around the year picker.
                }
                
                // Population list view shows the population data based on the selected filters.
                PopulationListView(viewModel: viewModel)
                
                Spacer() // Adds flexible space at the bottom, pushing content to the top.
            }
            .id("vstack") // Adds an ID for testing or tracking.
            .disabled(viewModel.isLoading) // Disables interaction when data is loading.
            .navigationTitle("Population Data") // Sets the title for the navigation bar.
        }
        .id("navigationView") // Adds an ID for the entire navigation view, useful for testing.
    }
    
}

#Preview {
    ContentView()
}
