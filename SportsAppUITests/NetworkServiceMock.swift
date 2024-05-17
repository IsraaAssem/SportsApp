//
//  NetworkServiceMock.swift
//  SportsAppTests
//
//  Created by Israa Assem on 15/05/2024.
//

import XCTest
@testable import SportsApp
class NetworkServiceMock:NetworkServiceProtocol{
    var shouldReturnError:Bool
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    enum FetchError:Error{
        case error
    }

    let fakeJson:[String:Any] = [
      "success": 1,
      "result": [
        [
          "league_key": 101,
          "league_name": "Premier League",
          "country_key": 44,
          "country_name": "England",
          "league_logo": "https://example.com/logos/premier-league.png",
          "country_logo": "https://example.com/logos/england.png"
        ],
        [
          "league_key": 102,
          "league_name": "La Liga",
          "country_key": 34,
          "country_name": "Spain",
          "league_logo": "https://example.com/logos/la-liga.png",
          "country_logo": "https://example.com/logos/spain.png"
        ]
      ]
    ]

    
    func fetchData<FootballLeageResponse>(url: URL, completion: @escaping (Result<FootballLeageResponse, Error>) -> Void) where FootballLeageResponse : Decodable {
        if(shouldReturnError) {
            completion(.failure(FetchError.error))
        } else {
            do {
                let data = try JSONSerialization.data(withJSONObject: fakeJson)
                let result = try JSONDecoder().decode(FootballLeageResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }

    
}
