//
//  PopulationViewModel.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import SwiftUI
import Combine

final class PopulationViewModel: ObservableObject {
    // Published properties that notify observers of changes, enabling SwiftUI views to reactively update.
    @Published var filteredData: [PopulationInformation] = [] // Filtered population data based on search text and selected year.
    @Published var errorMessage: String? // Holds error messages, if any, during data fetching or filtering.
    @Published var isLoading: Bool = false // Indicates if data is currently being fetched.
    @Published var isNoSearchResults: Bool = false // Tracks if a search yields no results.
    
    @Published var selectedYear: String = "" { // The year selected for filtering data.
        didSet {
            loadDataForSelectedYear() // Reloads data whenever the selected year changes.
        }
    }
    
    @Published var type: DataType { // The type of data (e.g., state or nation) selected.
        didSet {
            errorMessage = nil // Clear any previous error message when changing type.
            dataFilter = dataFilterFactory.createFilter(for: type) // Create a new filter based on the data type.
            fetchPopulationData() // Fetch new data for the updated type.
        }
    }
    
    @Published var searchText: String = "" // The search text used to filter population data.
    @Published var availableYears: [String] = [] // Array of available years in the data set.
    
    private var populationData: [PopulationInformation] = [] // Unfiltered population data for the selected year.
    
    // Services and dependencies injected through the initializer, allowing for easy testing and modularity.
    private let networkService: NetworkServiceProtocol
    private let dataFilterFactory: DataFilterFactoryProtocol
    private let errorHandler: ErrorHandlerProtocol
    
    private var allData: [PopulationInformation] = [] { // All fetched population data, updated when new data is fetched.
        didSet {
            loadAvailableYears() // Loads years whenever new data is set.
        }
    }
    
    private var dataFilter: DataFilterProtocol // The active data filter based on the current data type.
    private var fetchTask: Task<Void, Never>? // Holds the current fetching task to support cancellation.
    private var cancellables = Set<AnyCancellable>() // Stores Combine cancellables for handling publisher events.
    
    // Initializer sets up dependencies and begins data fetching.
    init(networkService: NetworkServiceProtocol = NetworkService(),
         dataFilterFactory: DataFilterFactoryProtocol = DefaultDataFilterFactory(),
         errorHandler: ErrorHandlerProtocol = DefaultErrorHandler(),
         type: DataType = .state) {
        
        self.networkService = networkService
        self.dataFilterFactory = dataFilterFactory
        self.errorHandler = errorHandler
        self.type = type
        self.dataFilter = dataFilterFactory.createFilter(for: type)
        
        fetchPopulationData() // Fetch initial data on initialization.
        
        // Set up a debounce on search text changes to optimize search performance.
        $searchText
            .debounce(for: .milliseconds(700), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterData() // Call filterData after debounce delay.
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancelFetchOperation() // Cancel any ongoing fetch when deinitialized.
        cancellables.forEach { $0.cancel() } // Cancel all Combine subscriptions.
    }
    
    // Cancels any existing fetch task and initiates a new data fetch.
    func fetchPopulationData() {
        cancelFetchOperation() // Cancel ongoing fetch if any.
        fetchTask = Task {
            await loadPopulationData() // Start new fetch task.
        }
    }
    
    // Resets the search text, triggering an update to show all data for the selected year.
    func resetSearch() {
        searchText = ""
    }
    
    // Cancels any ongoing fetch task.
    func cancelFetchOperation() {
        fetchTask?.cancel()
    }
    
    // Loads population data asynchronously and handles potential errors.
    @MainActor private func loadPopulationData() async {
        errorMessage = nil
        do {
            isLoading = true // Set loading to true at start of fetch.
            let data = try await networkService.fetchPopulationData(type: type) // Fetch data.
            isLoading = false
            if Task.isCancelled { return } // Exit if the task was cancelled.
            allData = data // Set the fetched data.
            loadDataForSelectedYear() // Load data specific to the selected year.
        } catch {
            isLoading = false
            if error is CancellationError { return } // Ignore cancellation errors.
            errorMessage = errorHandler.handleError(error) // Handle other errors.
        }
    }
    
    // Populates `availableYears` from `allData`, ensuring they are unique and sorted.
    private func loadAvailableYears() {
        let yearsSet = Set(allData.compactMap { $0.year }) // Extract unique years.
        availableYears = Array(yearsSet).sorted().reversed() // Sort years in descending order.
        if let firstYear = availableYears.first {
            selectedYear = firstYear // Set default to most recent year.
        } else {
            selectedYear = ""
            errorMessage = "No data available for the selected type." // Show message if no data.
        }
    }
    
    // Loads data filtered by the selected year, then applies the search filter.
    private func loadDataForSelectedYear() {
        filterDataByYear() // Filter by the selected year.
        filterData() // Apply additional search filter.
    }
    
    // Filters `allData` to only include entries from the selected year.
    private func filterDataByYear() {
        populationData = allData.filter { $0.year == selectedYear }
    }
    
    // Filters `populationData` based on the search text, using `dataFilter`.
    private func filterData() {
        filteredData = dataFilter.filter(data: populationData, searchText: searchText) // Apply filter.
        isNoSearchResults = filteredData.isEmpty // Set flag if no results.
    }
}

