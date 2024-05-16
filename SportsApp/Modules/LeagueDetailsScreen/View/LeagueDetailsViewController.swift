//
//  LeagueDetailsViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 14/05/2024.
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    @IBOutlet weak var leagueDetailsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        switch indexPath.section{
        case 0:
            cell=collectionView.dequeueReusableCell(withReuseIdentifier: "eventsCell", for: indexPath) as! EventsCollectionViewCell
        case 1:
            cell=collectionView.dequeueReusableCell(withReuseIdentifier: "resultsCell", for: indexPath) as! ScoresCollectionViewCell
        default:
            cell=collectionView.dequeueReusableCell(withReuseIdentifier: "teamsCell", for: indexPath) as! TeamsCollectionViewCell
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
