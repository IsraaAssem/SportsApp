//
//  FinalResultScoresResponse.swift
//  SportsApp
//
//  Created by Israa Assem on 16/05/2024.
//

import Foundation

struct EventResponse: Codable {
    let success: Int
    let result: [Event]
}

struct Event: Codable {
    let eventDate, eventTime, eventHomeTeam: String?
    let eventAwayTeam: String?
    let  eventFinalResult: String?
    let leagueKey: Int?
    let homeTeamLogo, awayTeamLogo: String?


    enum CodingKeys: String, CodingKey {
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
      
        case eventFinalResult = "event_final_result"
        case leagueKey = "league_key"
        
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
      
    }
}

