import SwiftUI

struct MatchView: View {
    let match: Match
    
    var body: some View {
        VStack(alignment: .leading) {
            // Competition Logo
            AsyncImage(url: URL(string: match.competition.emblem)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView()
            }
            
            // Match Details
            HStack {
                VStack(alignment: .leading) {
                    Text(match.homeTeam.name)
                        .font(.headline)
                    AsyncImage(url: URL(string: match.homeTeam.crest)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        ProgressView()
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(match.awayTeam.name)
                        .font(.headline)
                    AsyncImage(url: URL(string: match.awayTeam.crest)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
            }
            
            // Score Display
            if let homeScore = match.score.fullTime.home, let awayScore = match.score.fullTime.away {
                HStack {
                    Text(match.homeTeam.tla)
                        .font(.title2)
                        .bold(homeScore > awayScore)
                        .foregroundColor(homeScore > awayScore ? .green : .black)
                    Text("\(homeScore) - \(awayScore)")
                        .font(.title2)
                    Text(match.awayTeam.tla)
                        .font(.title2)
                        .bold(awayScore > homeScore)
                        .foregroundColor(awayScore > homeScore ? .green : .black)
                }
            } else {
                Text("Not Started")
            }
            
            Group {
                // Match Date and Time
                Text(formatDate(match.utcDate))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Competition and Matchday
                Text("\(match.competition.name) - Matchday \(match.matchday)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(match.id)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
        }
        .padding()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
