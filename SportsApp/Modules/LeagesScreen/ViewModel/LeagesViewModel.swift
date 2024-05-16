//
//  LeagesViewModel.swift
//  SportsApp
//
//  Created by Israa Assem on 14/05/2024.
//

import Foundation
protocol LeagesViewModelProtocol{
    var bindLeagesToViewController:()->Void { get set }
    func getLeagesCount()->Int
    func getLeages()->[FootballLeage]
    func fetchLeages()->Void
    func getSportIndex()->Int
}
class LeagesViewModel:LeagesViewModelProtocol{
    var sportIndex=0
    let networkService:NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    var bindLeagesToViewController:()->Void={}
    var footballLeages:[FootballLeage]?=nil
    func fetchLeages(){
        let url = URL(string: "https://apiv2.allsportsapi.com/\(sportsDict[sportIndex]!)/?met=Leagues&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db")!
        networkService.fetchData(url: url) { [weak self](result:Result<FootballLeageResponse,Error>) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                self?.footballLeages=data.result
                self?.bindLeagesToViewController()
            }
        }
    }
    func getLeages()->[FootballLeage]{
        return footballLeages ?? []
    }
    func getLeagesCount()->Int{
        return footballLeages?.count ?? 0
    }
    func getSportIndex()->Int{
        return sportIndex
    }
    let sportsDict=[0:"football",1:"basketball",2:"cricket",3:"tennis"]
}
