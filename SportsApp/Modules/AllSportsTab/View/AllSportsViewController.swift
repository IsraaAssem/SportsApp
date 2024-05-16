//
//  HomeViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 11/05/2024.
//

import UIKit

class AllSportsViewController: UIViewController {
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    let allSportsViewModel:AllSportsViewModelProtocol=AllSportsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title="Sports"
        sportsCollectionView.delegate=self
        sportsCollectionView.dataSource=self
    }
    
}
extension AllSportsViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
         guard let leagesViewController = storyboard?.instantiateViewController(withIdentifier: "leages") as? LeagesViewController else {
             return
         }
        let leagesViewModel=LeagesViewModel(networkService: NetworkService())
        leagesViewModel.sportIndex=indexPath.row
        leagesViewController.leagesViewModel=leagesViewModel
         navigationController?.pushViewController(leagesViewController, animated: true)
    }
}
extension AllSportsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSportsViewModel.getSportsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AllSportsCollectionViewCell
        cell.sportImage.image=UIImage(named:allSportsViewModel.getSportsArray()[indexPath.item].image)
        cell.sportName.text=allSportsViewModel.getSportsArray()[indexPath.row].name
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=1
        cell.layer.cornerRadius=20
        return cell
    }
    
    
}
extension AllSportsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.487
        let height=width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
