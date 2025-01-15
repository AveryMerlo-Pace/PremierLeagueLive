//
//  Match.swift
//  PremierLeagueLive
//
//  Created by Avery Merlo on 11/23/24.
//

import Foundation

struct Match: Codable, Identifiable {
    var competition: Competition
    var utcDate: String
    var status: String
    var matchday: Int
    var stage: String
    var homeTeam: Team
    var awayTeam: Team
    var score: Score
    
    enum CodingKeys: String, CodingKey {
        case competition = "competition"
        case utcDate = "utcDate"
        case status = "status"
        case matchday = "matchday"
        case stage = "stage"
        case homeTeam = "homeTeam"
        case awayTeam = "awayTeam"
        case score = "score"
    }
    
    var id: String {
        return "\(homeTeam.name)-\(awayTeam.name)-\(utcDate)"
    }
    
    var isLive: Bool {
       return status == "IN_PLAY"
    }
    
    var isOver: Bool {
        return status == "FINISHED"
    }

    var hasNotStarted: Bool {
        return status == "TIMED"
    }
    
    // Computed property to parse the date string and return a Date object
    var date: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: utcDate)
    }
    
    struct Competition: Codable, Identifiable {
        var id: Int?
        var name: String
        var code: String
        var type: String
        var emblem: String
    }

    struct Season: Codable {
        var id: Int
        var name: String
        var startDate: String
        var endDate: String
        var currentMatchday: Int
    }
    
    struct Team: Codable {
        var id: Int
        var name: String
        var shortName: String
        var tla: String
        var crest: String
    }
    
    struct Score: Codable {
        var winner: String?
        var duration: String
        var fullTime: Time
        var halfTime: Time
        
        struct Time: Codable {
            var home: Int?
            var away: Int?
        }
    }
    
    struct Referee: Codable {
        var id: Int
        var name: String
        var nationality: String?
    }
}

struct MatchData: Decodable {
    var matches: [Match]
}


class MatchAPI {
    private let apiKey = "9ddd2bae6d61416fa1a85f7dca1569a6"
    private let baseURL = "https://api.football-data.org/v4"
    
    // Replace 2021 with the correct ID if it's different
    private let premierLeagueId = 2021

    func fetchPremierLeagueGames(for date: String, completion: @escaping ([Match]?) -> Void) {
        guard let encodedDate = date.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/matches?date=\(encodedDate)") else {
            print("Invalid URL or date encoding")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
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
              print("Raw JSON: \(jsonString)")
            }
            

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let matchData = try decoder.decode(MatchData.self, from: data)
                //print("Decoded LeagueData: \(leagueData)") // Full object for debugging

                let allMatches = matchData.matches
                print("Total matches: \(allMatches.count)")
                completion(allMatches)

            } catch {
                print("Error decoding LeagueData: \(error)")
                completion(nil)
            }

        }.resume()
    }
}
