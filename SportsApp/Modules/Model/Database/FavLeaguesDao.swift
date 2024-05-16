//
//  FavLeaguesDao.swift
//  SportsApp
//
//  Created by Israa Assem on 16/05/2024.
//


import UIKit
import CoreData
struct MoviesDao{
    let context:NSManagedObjectContext!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    init(){
         context = delegate.persistentContainer.viewContext
    }
    func saveFavLeaguesToCoreData(leaguesToStore: [FavLeaguesModel]) {
        for leagueToStore in leaguesToStore {
            guard let leagueEntity = NSEntityDescription.entity(forEntityName: "FavLeagues", in: context) else {
                print("FavLeagues entity description not found")
                return
            }
            let league = NSManagedObject(entity: leagueEntity, insertInto: context)
            league.setValue(leagueToStore.leagueName, forKey: "leagueName")
            league.setValue(leagueToStore.leagueLogo, forKey: "leagueLogo")
            league.setValue(leagueToStore.leagueId, forKey: "leagueId")
            
            do {
                try context.save()
                print("FavLeague saved successfully!")
            } catch let error {
                print("Error saving FavLeague: \(error.localizedDescription)")
            }
        }
    }

    
    func retrieveStoredFavLeagues() -> [FavLeaguesModel] {
        var favLeagues: [FavLeaguesModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavLeagues")
        do {
            let fetchedLeagues = try context.fetch(fetchRequest)
            for case let league as NSManagedObject in fetchedLeagues {
                guard let name = league.value(forKey: "leagueName") as? String,
                      let logo = league.value(forKey: "leagueLogo") as? String,
                      let id = league.value(forKey: "leagueId") as? Int64 else {
                    continue
                }
                
                let leagueObject = FavLeaguesModel(leagueId: id, leagueLogo: logo, leagueName: name)
                favLeagues.append(leagueObject)
            }
        } catch {
            print("Failed to fetch leagues: \(error)")
        }
        print(favLeagues)
        return favLeagues
    }
    
    func deleteLeague(league: FavLeaguesModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavLeagues")
        let predicates: [NSPredicate] = [
            NSPredicate(format: "leagueName == %@", league.leagueName),
            NSPredicate(format: "leagueLogo == %@", league.leagueLogo),
            NSPredicate(format: "leagueId == %d", league.leagueId),
          ]
          let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
          
          fetchRequest.predicate = compoundPredicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            if let managedObject = fetchedObjects.first as? NSManagedObject {
                context.delete(managedObject)
                try context.save()
                print("League Deleted!")
            } else {
                print("League not found!")
            }
        } catch let error {
            print("Error deleting league: \(error.localizedDescription)")
        }
    }

}
