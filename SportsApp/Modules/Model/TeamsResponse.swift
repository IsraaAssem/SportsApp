//
//  TeamsResponse.swift
//  SportsApp
//
//  Created by Israa Assem on 16/05/2024.
//

import Foundation
struct TeamsResponse: Codable {
    let success: Int?
    let result: [Team]
}

struct Team: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}
