//
//  FavLeaguesViewModel.swift
//  SportsApp
//
//  Created by Israa Assem on 16/05/2024.
//

import Foundation
protocol FavLeaguesViewModelProtocol{
    func getFavLeaguesArr()->[FavLeaguesModel]
    func getFavLeagesArrCount()->Int
    func deleteFromFavLeagues(league:FavLeaguesModel)
    func retrieveStoredFavLeagues()
    var bindFavLeagesToViewController:()->Void{get set}
    func getCurrentLeage()->FavLeaguesModel
    func addLeagueToFav(league:FavLeaguesModel)
}
class FavLeaguesViewModel:FavLeaguesViewModelProtocol{
    var currentLeague:FavLeaguesModel!
    var favLeaguesDao:FavLeaguesDao?=nil
    var favLeagesArr:[FavLeaguesModel]=[]
    var bindFavLeagesToViewController:()->Void={}
    init(){
        favLeaguesDao=FavLeaguesDao()
    }
    func getFavLeaguesArr()->[FavLeaguesModel]{
        return favLeagesArr
    }
    func getCurrentLeage()->FavLeaguesModel{
        return currentLeague
    }
    func retrieveStoredFavLeagues(){
        favLeagesArr=favLeaguesDao?.retrieveStoredFavLeagues() ?? []
        bindFavLeagesToViewController()
    }
    func deleteFromFavLeagues(league:FavLeaguesModel){
        favLeaguesDao?.deleteLeague(league: league)
        retrieveStoredFavLeagues()
    }
    func getFavLeagesArrCount()->Int{
        return favLeagesArr.count
    }
    func addLeagueToFav(league:FavLeaguesModel){
        var arr=[FavLeaguesModel]()
        arr.append(league)
        favLeaguesDao?.saveFavLeaguesToCoreData(leaguesToStore:arr)
        retrieveStoredFavLeagues()
    }
}
