//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Israa Assem on 16/05/2024.
//

import Foundation
protocol LeagueDetailsViewModelProtocol{
    func fetchTeams()->Void
    func fetchEvents()->Void
    func getTeamsArray()->[Team]
    func getTeamsCount()->Int
    var bindLeagesToViewController:()->Void { get set }
    func getSportIndex()->Int
    func getLeagueId()->Int
    func getEventsArray()->[Event]
    func getEventsCount()->Int
}
class LeagueDetailsViewModel:LeagueDetailsViewModelProtocol{
    var sportIndex=0,leagueID=1
    var bindLeagesToViewController: () -> Void={}
    let networkService:NetworkServiceProtocol
    var teamsArray:[Team]=[]
    var eventsArray:[Event]=[]
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    func fetchTeams(){
        //teams
        print("in fetch: \(sportsDict[sportIndex]!)  , \(leagueID)")
        let url = URL(string: "https://apiv2.allsportsapi.com/\(sportsDict[sportIndex]!)/?&met=Teams&leagueId=\(leagueID)&APIkey=\(API_KEY)")!

        networkService.fetchData(url: url) { [weak self](result:Result<TeamsResponse,Error>) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                self?.teamsArray=data.result
                self?.bindLeagesToViewController()
            }
        }
    }
    func fetchEvents(){
        //events
        print("in fetch: \(sportsDict[sportIndex]!)  , \(leagueID)")
        let url = URL(string: "https://apiv2.allsportsapi.com/\(sportsDict[sportIndex]!)?met=Fixtures&leagueId=\(leagueID)&from=2023-01-18&to=2024-01-18&APIkey=\(API_KEY)")!

        networkService.fetchData(url: url) { [weak self](result:Result<EventResponse,Error>) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                self?.eventsArray=data.result
                self?.bindLeagesToViewController()
            }
        }
    }
    func getTeamsCount()->Int{
        return teamsArray.count
    }
    func getTeamsArray()->[Team]{
        return teamsArray
    }
    func getSportIndex()->Int{
        return sportIndex
    }
    func getLeagueId()->Int{
     return leagueID
    }
    func getEventsCount()->Int{
        return eventsArray.count
    }
    func getEventsArray()->[Event]{
        return eventsArray
    }
    
let sportsDict=[0:"football",1:"basketball",2:"cricket",3:"tennis"]
}



//events
//https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=205&from=2023-01-18&to=2024-01-18&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db

//https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=5&from=2023-01-18&to=2024-01-18&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db
