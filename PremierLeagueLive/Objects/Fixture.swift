//
//  Fixture.swift
//  PremierLeagueLive
//
//  Created by Avery Merlo on 1/16/25.
//

import Foundation

struct Response: Codable {
    var fixture: Fixture
    var league: League
    var teams: MatchTeams
    var goals: MatchGoals
    var score: MatchScore
    
    enum CodingKeys: String, CodingKey {
        case fixture = "fixture"
        case league = "league"
        case teams = "teams"
        case goals = "goals"
        case score = "score"
    }
    
    struct Fixture: Codable, Identifiable {
        var id: Int
        var referee: String? // Allow null value for referee
        var timezone: String
        var date: String
        var timestamp: Double
        var periods: Periods
        var venue: Venue
        var status: Status
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case referee = "referee"
            case timezone = "timezone"
            case date = "date"
            case timestamp = "timestamp"
            case periods = "periods"
            case venue = "venue"
            case status = "status"
        }
        
        var isLive: Bool {
            return status.short == "1H" || status.short == "2H"
        }
        
        var isHalftime: Bool {
            return status.short == "HT"
        }
        
        var isFinished: Bool {
            return status.short == "FT"
        }
        
        var hasNotStarted: Bool {
            return status.short == "NS"
        }
        
        struct Periods: Codable {
            var first: Double?
            var second: Double? // Allow null value for second period
        }
        
        struct Venue: Codable, Identifiable {
            var id: Int?
            var name: String?
            var city: String?
        }
        
        struct Status: Codable {
            var long: String
            var short: String
            var elapsed: Int?
            var extra: Int? // Allow null value for extra time
        }
    }
    
    struct League: Codable, Identifiable {
        var id: Int
        var name: String
        var country: String
        var logo: String
        var flag: String?
        var season: Int
        var round: String
    }
    
    struct MatchTeams: Codable {
        var home: Team
        var away: Team
    }
    
    struct Team: Codable, Identifiable {
        var id: Int
        var name: String
        var logo: String
        var winner: Bool? // Optional property for winner information
    }
    
    struct MatchGoals: Codable {
            var home: Int?
            var away: Int?
        }

    struct MatchScore: Codable {
        var halftime: Score
        var fulltime: Score? // Optional property for fulltime score (might not be available yet)
        var extratime: Score? // Optional property for extratime score (not applicable to all matches)
        var penalty: Score? // Optional property for penalty shootout score (not applicable to all matches)
        
        struct Score: Codable {
            var home: Int? // Optional property to handle potential missing values
            var away: Int? // Optional property to handle potential missing values
        }
    }
    
}

struct FixtureData: Codable {
    var response: [Response]?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

class FixtureAPI {
    private let apiKey2 = "098981b54c9cab935304f01bd57ded1e"
    private let baseURL2 = "https://v3.football.api-sports.io/fixtures"

    func fetchPremierLeagueGames(for date: String, completion: @escaping ([Response]?) -> Void) {
        guard let encodedDate = date.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL2)?date=\(encodedDate)") else {
            print("Invalid URL or date encoding")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        
        request.addValue("x-rapidapi-host", forHTTPHeaderField: "api-football-v3.p.rapidapi.com")
        request.addValue(apiKey2, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            
            //Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
              //print("Raw JSON: \(jsonString)")
            }
            

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let fixtureData = try decoder.decode(FixtureData.self, from: data)
                //print("Decoded LeagueData: \(leagueData)") // Full object for debugging

                let response = fixtureData.response
                print("Total matches: \((response?.count ?? 0)/5)")
                completion(response)

            } catch {
                print("Error decoding LeagueData: \(error)")
                completion(nil)
            }

        }.resume()
    }
}
