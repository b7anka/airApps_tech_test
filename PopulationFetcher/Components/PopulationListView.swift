//
//  PopulationListView.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import SwiftUI

struct PopulationListView: View {
    
    // Observes the view model for changes, allowing the view to update reactively.
    @ObservedObject var viewModel: PopulationViewModel
    
    var body: some View {
        List {
            // Shows a loading indicator when data is being fetched.
            if viewModel.isLoading {
                ProgressView("Loading...") // Displays a loading message.
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Centers the ProgressView within the List.
                    .id("ProgressView") // Adds an ID for testing purposes.
            }
            // Displays an error message if there is an error in fetching data.
            else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red) // Sets error message color to red.
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Centers the error message within the List.
            }
            // Displays a message when there are no results for the current search.
            else {
                if viewModel.filteredData.isEmpty {
                    Text("No results found for search term: \(viewModel.searchText)")
                        .foregroundColor(.gray) // Sets "no results" message color to gray.
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Centers the "no results" message within the List.
                }
                // Populates the list with filtered data when available.
                else {
                    ForEach(viewModel.filteredData) { data in
                        NavigationLink(destination: DetailsView(data: data, type: viewModel.type)) {
                            VStack(alignment: .leading) {
                                // Displays the name based on the data type (state or nation).
                                Text(viewModel.type == .state ? data.state ?? "Unknown" : data.nation ?? "Unknown")
                                    .font(.headline) // Sets main text style to headline.
                                // Displays the population count with separators or a placeholder if unavailable.
                                Text("Population: \(data.population?.formattedWithSeparator ?? "Unknown Population")")
                                    .font(.subheadline) // Sets subtitle text style.
                            }
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle()) // Sets the list style to plain, which removes dividers.
        .searchable(text: $viewModel.searchText) // Adds a search bar bound to the view model's search text.
    }
    
}


