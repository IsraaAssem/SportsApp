//
//  AllSportsViewModel.swift
//  SportsApp
//
//  Created by Israa Assem on 12/05/2024.
//

import Foundation
protocol AllSportsViewModelProtocol{
    func getSportsCount()->Int
    func getSportsArray()->[Sport]
}
class AllSportsViewModel:AllSportsViewModelProtocol{
    var sportsArray:[Sport]?
    init(){
        sportsArray=createSportsArray()
    }
    func getSportsCount() -> Int {
        return sportsArray?.count ?? 0
    }
    
    func getSportsArray() -> [Sport] {
        return sportsArray ?? []
    }
    
    func createSportsArray()->[Sport]{
        var sportsArr=[Sport]()
        sportsArr.append(Sport(name: "Football", image: "football"))
        sportsArr.append(Sport(name: "Basketball", image: "basketball"))
        sportsArr.append(Sport(name: "Cricket", image: "cricket"))
        sportsArr.append(Sport(name: "Tennis", image: "tennis"))
       return sportsArr
    }
    
}
