//
//  FootballLeagesMdel.swift
//  SportsApp
//
//  Created by Israa Assem on 14/05/2024.
//

import Foundation
struct FootballLeageResponse: Codable {
    let success: Int
    let result: [FootballLeage]
}


struct FootballLeage: Codable {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int
    let countryName: String
    let leagueLogo: String?
    let countryLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}


