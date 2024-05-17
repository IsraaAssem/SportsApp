//
//  LeagueDetailsViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 14/05/2024.
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    @IBOutlet weak var leagueDetailsCollectionView: UICollectionView!
    var favLeaguesViewModel:FavLeaguesViewModelProtocol!
    var alreadyInFavorites:Bool=false
    var leagueDetailsViewModel:LeagueDetailsViewModelProtocol!
    @IBOutlet weak var favLeagueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favLeaguesViewModel?.retrieveStoredFavLeagues()
        //leagueDetailsViewModel=LeagueDetailsViewModel(networkService: NetworkService())
        if let currentLeagueId = favLeaguesViewModel?.getCurrentLeage().leagueId {
            if favLeaguesViewModel.getFavLeaguesArr().contains { $0.leagueId == currentLeagueId } {
                alreadyInFavorites=true
                favLeagueBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                alreadyInFavorites=false
                favLeagueBtn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            }
        } else {
        }
        
        leagueDetailsCollectionView.delegate=self
        leagueDetailsCollectionView.dataSource=self
        let layout=UICollectionViewCompositionalLayout{[weak self] index,environment in
            if index==0{
                return self?.drawEventsSection()
            }else if index==1{
                return self?.drawScoreSection()
            }else{
                return self?.drawTeamsSection()
            }
            
        }
        leagueDetailsCollectionView.setCollectionViewLayout(layout, animated: true)
        leagueDetailsCollectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        leagueDetailsViewModel.fetchTeams()
        leagueDetailsViewModel.fetchEvents()
        leagueDetailsViewModel.bindLeagesToViewController={[weak self] in
            DispatchQueue.main.async{
                self?.leagueDetailsCollectionView.reloadData()
            }
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func addToFavBtn(_ sender: Any) {
        if alreadyInFavorites{
            var deleteAlert=UIAlertController(title: "Delete League", message: "Are you sure you want to delete this league from favorites?", preferredStyle: UIAlertController.Style.alert)
            var deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
                self?.favLeaguesViewModel.deleteFromFavLeagues(league: (self?.favLeaguesViewModel?.getCurrentLeage())!)
                self?.alreadyInFavorites=false
                self?.favLeagueBtn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            })
            var cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }else{
            favLeaguesViewModel.addLeagueToFav(league: favLeaguesViewModel?.getCurrentLeage() ?? FavLeaguesModel(leagueId: 28, leagueLogo: "https://apiv2.allsportsapi.com/logo/logo_leagues/28_world-cup.png", leagueName: "World Cup"))
            alreadyInFavorites=true
            favLeagueBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            var deleteAlert=UIAlertController(title: nil, message: "League is added to favorites successfully.", preferredStyle: UIAlertController.Style.alert)
           
            var confirmationAction=UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            
            deleteAlert.addAction(confirmationAction)
            self.present(deleteAlert, animated: true, completion: nil)
            
        }
    }
    func  drawEventsSection()->NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        //section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
        items.forEach { item in
        let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
        let minScale: CGFloat = 0.8
        let maxScale: CGFloat = 1.0
        let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
        item.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        }
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    func drawScoreSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func drawTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
        items.forEach { item in
        let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
        let minScale: CGFloat = 0.8
        let maxScale: CGFloat = 1.0
        let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
        item.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        }
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
}
extension LeagueDetailsViewController:UICollectionViewDelegate{
    
}
extension LeagueDetailsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return leagueDetailsViewModel.getEventsCount()
        case 1:
            return leagueDetailsViewModel.getEventsCount()
        default:
            return leagueDetailsViewModel.getTeamsCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell!
        switch indexPath.section{
        case 0:
           let eventsCell=collectionView.dequeueReusableCell(withReuseIdentifier: "eventsCell", for: indexPath) as! EventsCollectionViewCell
            if let urlString = leagueDetailsViewModel?.getEventsArray()[indexPath.row].homeTeamLogo,
               let url = URL(string: urlString) {
                eventsCell.homeTeameImage.kf.setImage(with: url, placeholder: UIImage(named: "leagueImage"))
            } else {
                eventsCell.homeTeameImage.image = UIImage(named: "leagueImage")
            }
            if let urlString = leagueDetailsViewModel?.getEventsArray()[indexPath.row].awayTeamLogo,
               let url = URL(string: urlString) {
                eventsCell.awayTeamImage.kf.setImage(with: url, placeholder: UIImage(named: "leagueImage"))
            } else {
                eventsCell.awayTeamImage.image = UIImage(named: "leagueImage")
            }
            eventsCell.homeTeamNAme.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventHomeTeam
            eventsCell.awayTeamName.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventAwayTeam
            eventsCell.date.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventDate
            eventsCell.time.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventTime
            
            cell=eventsCell
        case 1:
            let resultsCell=collectionView.dequeueReusableCell(withReuseIdentifier: "resultsCell", for: indexPath) as! ScoresCollectionViewCell
            if let urlString = leagueDetailsViewModel?.getEventsArray()[indexPath.row].homeTeamLogo,
               let url = URL(string: urlString) {
                resultsCell.homeTeamImage.kf.setImage(with: url, placeholder: UIImage(named: "leagueImage"))
            } else {
                resultsCell.homeTeamImage.image = UIImage(named: "leagueImage")
            }
            if let urlString = leagueDetailsViewModel?.getEventsArray()[indexPath.row].awayTeamLogo,
               let url = URL(string: urlString) {
                resultsCell.awayTeamImage.kf.setImage(with: url, placeholder: UIImage(named: "leagueImage"))
            } else {
                resultsCell.awayTeamImage.image = UIImage(named: "leagueImage")
            }
            resultsCell.homeTeamName.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventHomeTeam
            resultsCell.awayTeamName.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventAwayTeam
            resultsCell.date.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventDate
            resultsCell.time.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventTime
            resultsCell.finalResult.text=leagueDetailsViewModel?.getEventsArray()[indexPath.row].eventFinalResult
            cell=resultsCell
        default:
            let teamsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamsCell", for: indexPath) as! TeamsCollectionViewCell
                
                if let urlString = leagueDetailsViewModel?.getTeamsArray()[indexPath.row].teamLogo,
                   let url = URL(string: urlString) {
                    teamsCell.teamImage.kf.setImage(with: url, placeholder: UIImage(named: "leagueImage"))
                } else {
                    teamsCell.teamImage.image = UIImage(named: "leagueImage")
                }
                cell = teamsCell
        }
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView

        switch indexPath.section {
        case 0:
            headerView.titleLabel.text = "Upcoming Events"
        case 1:
            headerView.titleLabel.text = "Latest Results"
        case 2:
            headerView.titleLabel.text = "Teams"
        default:
            headerView.titleLabel.text = ""
        }

        return headerView
    }

}
