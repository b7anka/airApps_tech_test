//
//  DetailsView.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import SwiftUI

struct DetailsView: View {
    
    // The view model is wrapped in a @StateObject, meaning this view will observe and react to changes in the view model's data.
    @StateObject var viewModel: DetailsViewModel
    
    // Custom initializer that accepts population data and data type, initializing the DetailsViewModel accordingly.
    init(data: PopulationInformation, type: DataType) {
        // Initializes the view model as a StateObject, ensuring it is owned by this view.
        self._viewModel = StateObject(wrappedValue: DetailsViewModel(data: data, type: type))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header section displaying the title and ID.
            HStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text(viewModel.id)
                    .font(.headline)
                    .bold()
            }
            
            // Displays year and population information using createTextView helper.
            createTextView(title: "Year", value: viewModel.year)
            createTextView(title: "Population", value: viewModel.population)
            
            // Loops through additional info in viewModel, creating a text view for each item.
            ForEach(viewModel.additionalInfo, id: \.title) { info in
                createTextView(title: info.title, value: info.value)
            }
            
            Spacer() // Adds flexible spacing at the bottom to push content to the top.
        }
        .padding() // Adds padding around the VStack content.
        .navigationTitle(viewModel.title) // Sets navigation title to the title from the view model.
        .navigationBarTitleDisplayMode(.inline) // Uses inline display mode for the navigation title.
    }
    
    // Helper function that creates a standardized Text view for displaying a title-value pair.
    private func createTextView(title: String, value: String) -> some View {
        Text("\(title): \(value)")
            .font(.title2) // Sets font size and style for the text.
    }
    
}

#Preview {
    DetailsView(data: .init(nationID: "1", stateID: "1", nation: "USA", state: "New York", year: "2020", population: 1000000000), type: .state)
}
