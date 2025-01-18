//
//  ContentView.swift
//  PremierLeagueLive
//
//  Created by Avery Merlo on 11/23/24.
//
import SwiftUI

struct FixtureListView: View {
    @State private var response: [Response] = []
    @State private var selectedDate = Date()
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    HStack {
                        Button("Today") {
                            selectedDate = Date() // Reset to current date
                            fetchFixturesForSelectedDate() // Fetch games for today
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        // Date Picker
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    }
                    .padding(.horizontal)
                    
                    Text("Fixtures")
                        .font(.largeTitle)
                        .frame(alignment: .leading)
                        .bold()
                    
                }
                // Loading Indicator
                if isLoading {
                    Spacer()
                    ProgressView("Loading games...")
                        .padding()
                    Spacer()
                } else {
                    
                }
            }
            .onChange(of: selectedDate) { _ in
                fetchFixturesForSelectedDate()
            }
            .onAppear {
                fetchFixturesForSelectedDate()
            }
        }
    }
    
    // Fetch games for the selected date
    private func fetchFixturesForSelectedDate() {
        let formattedDate = formatApiDate(selectedDate)
        // print("Formatted date for API call: \(formattedDate)")
        
        isLoading = true
        let api = FixtureAPI()
        api.fetchPremierLeagueGames(for: formattedDate) { response in
            DispatchQueue.main.async {
                if let response = response {
                    // print("Fetched matches: \(games)")
                    self.response = response
                } else {
                    print("Error: Data missing or malformed")
                    // Handle the missing data gracefully, e.g. show an alert or retry
                }
                self.isLoading = false
            }
        }
    }
    
    // Helper function to format a date for API call (yyyy-MM-dd)
    private func formatApiDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    // Helper function to format the UTC date string for display (e.g., "Jan 1, 2024, 12:00 PM")
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Format the API date string
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

