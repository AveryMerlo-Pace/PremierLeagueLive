//
//  ContentView.swift
//  PremierLeagueLive
//
//  Created by Avery Merlo on 11/23/24.
//
import SwiftUI

struct MatchListView: View {
    @State private var matches: [Match] = []
    @State private var selectedDate = Date()
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    HStack {
                        Button("Today") {
                            selectedDate = Date() // Reset to current date
                            fetchGamesForToday() // Fetch games for today
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
                    
                    Text("Matches")
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
                    // Matches List
                    List {
                        ForEach(Array(Dictionary(grouping: matches, by: \.competition.name).sorted(by: { $0.key < $1.key })), id: \.key) { (competitionName, matches) in
                            Section(header:
                                        HStack {
                                AsyncImage(url: URL(string: matches.first?.competition.emblem ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    ProgressView()
                                }
                                Text("\(competitionName)")
                                    .font(.title2)
                                    .foregroundStyle(Color.black)
                                    .bold()
                            }
                            ) {
                                ForEach(matches) { match in
                                    NavigationLink(destination: MatchView(match: match)) {
                                        VStack(spacing: 0) { // Ensure spacing is zero
                                            HStack {
                                                AsyncImage(url: URL(string: match.homeTeam.crest)!) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                Text(match.homeTeam.name)
                                                //Spacer()
                                                //Text("vs")
                                                Spacer()
                                                AsyncImage(url: URL(string: match.awayTeam.crest)!) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                Text(match.awayTeam.name)
                                            }
                                            Spacer()
                                            Group {
                                                //Text("\(match.homeTeam.shortName) vs \(match.awayTeam.shortName)")
                                                if match.isLive {
                                                    if let homeScore = match.score.fullTime.home, let awayScore = match.score.fullTime.away {
                                                        VStack {
                                                            HStack {
                                                                Text("\(match.homeTeam.tla)")
                                                                    .font(.title2)
                                                                    .bold(homeScore > awayScore)
                                                                    .foregroundColor(homeScore > awayScore ? .green : .black)
                                                                Text("\(homeScore)")
                                                                    .font(.title2)
                                                                    .bold(homeScore > awayScore)
                                                                    .foregroundColor(homeScore > awayScore ? .green : .black)
                                                                Text("-")
                                                                    .font(.title2)
                                                                Text("\(awayScore)")
                                                                    .font(.title2)
                                                                    .bold(awayScore > homeScore)
                                                                    .foregroundColor(awayScore > homeScore ? .green : .black)
                                                                Text("\(match.awayTeam.tla)")
                                                                    .font(.title2)
                                                                    .bold(awayScore > homeScore)
                                                                    .foregroundColor(awayScore > homeScore ? .green : .black)
                                                            }
                                                            Text("LIVE")
                                                                .font(.subheadline)
                                                                .bold()
                                                                .foregroundColor(.green)
                                                                .opacity(50.0)
                                                        }
                                                    }
                                                } else if match.isHalftime {
                                                    if let homeScore = match.score.fullTime.home, let awayScore = match.score.fullTime.away {
                                                        VStack {
                                                            HStack {
                                                                Text("\(match.homeTeam.tla)")
                                                                    .font(.title2)
                                                                    .bold(homeScore > awayScore)
                                                                    .foregroundColor(homeScore > awayScore ? .green : .black)
                                                                Text("\(homeScore)")
                                                                    .font(.title2)
                                                                    .bold(homeScore > awayScore)
                                                                    .foregroundColor(homeScore > awayScore ? .green : .black)
                                                                Text("-")
                                                                    .font(.title2)
                                                                Text("\(awayScore)")
                                                                    .font(.title2)
                                                                    .bold(awayScore > homeScore)
                                                                    .foregroundColor(awayScore > homeScore ? .green : .black)
                                                                Text("\(match.awayTeam.tla)")
                                                                    .font(.title2)
                                                                    .bold(awayScore > homeScore)
                                                                    .foregroundColor(awayScore > homeScore ? .green : .black)
                                                            }
                                                            Text("HT")
                                                                .font(.subheadline)
                                                                .bold()
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                    
                                                } else {
                                                    if let homeScore = match.score.fullTime.home, let awayScore = match.score.fullTime.away {
                                                        VStack {
                                                            HStack {
                                                                Text("\(match.homeTeam.tla)")
                                                                    .font(.title2)
                                                                    .bold(homeScore > awayScore)
                                                                    .foregroundColor(homeScore > awayScore ? .green : .black)
                                                                Text("\(homeScore)")
                                                                    .font(.title2)
                                                                    .bold(homeScore > awayScore)
                                                                    .foregroundColor(homeScore > awayScore ? .green : .black)
                                                                Text("-")
                                                                    .font(.title2)
                                                                Text("\(awayScore)")
                                                                    .font(.title2)
                                                                    .bold(awayScore > homeScore)
                                                                    .foregroundColor(awayScore > homeScore ? .green : .black)
                                                                Text("\(match.awayTeam.tla)")
                                                                    .font(.title2)
                                                                    .bold(awayScore > homeScore)
                                                                    .foregroundColor(awayScore > homeScore ? .green : .black)
                                                            }
                                                            Text("FT")
                                                                .font(.subheadline)
                                                                .foregroundStyle(Color.black)
                                                                .bold()
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            Spacer()
                                            Group {
                                                if match.hasNotStarted {
                                                    Text(formatDate(match.utcDate))
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                    Text("\(match.competition.name), Matchday \(match.matchday)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 5) // Adjust padding as needed
                        .listRowBackground(Color.clear) // Ensure no background color
                    }
                    .listStyle(.plain)
                }
            }
            .onChange(of: selectedDate) { _ in
                fetchGamesForSelectedDate()
            }
            .onAppear {
                fetchGamesForToday()
            }
        }
    }

    // Fetch games for the selected date
    private func fetchGamesForSelectedDate() {
        let formattedDate = formatApiDate(selectedDate)
        // print("Formatted date for API call: \(formattedDate)")

        isLoading = true
        let api = MatchAPI()
        api.fetchPremierLeagueGames(for: formattedDate) { games in
            DispatchQueue.main.async {
                if let games = games {
                    // print("Fetched matches: \(games)")
                    self.matches = games
                } else {
                    print("Error: Data missing or malformed")
                    // Handle the missing data gracefully, e.g. show an alert or retry
                }
                self.isLoading = false
            }
        }
    }
    
    // Fetch games for today's date
    private func fetchGamesForToday() {
        let formattedDate = formatApiDate(Date())

        isLoading = true
        let api = MatchAPI()
        api.fetchPremierLeagueGames(for: formattedDate) { allMatches in
            DispatchQueue.main.async {
                if let allMatches = allMatches {
                    // print("Fetched \(allMatches.count) matches.") // Debugging
                    self.matches = allMatches
                } else {
                    print("No matches found or data error.")
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

#Preview {
    MatchListView()
}
