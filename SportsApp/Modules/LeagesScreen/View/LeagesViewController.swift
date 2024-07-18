//
//  LeagesViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 13/05/2024.
//

import UIKit
import Kingfisher
class LeagesViewController: UIViewController {
    
    let indicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var leagesTable: UITableView!
    var leagesViewModel:LeagesViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        leagesTable.delegate=self
        leagesTable.dataSource=self
        setTableTitle()
        setTableBackgroundColor()
        leagesViewModel?.bindLeagesToViewController={[weak self] in
            DispatchQueue.main.async{
                self?.leagesTable.reloadData()
                self?.stopIndicator()
            }
        }
        leagesViewModel?.fetchLeages()
        leagesTable.registerNib(cell: LeagesTableViewCell.self)
        indicator.center = self.view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    func stopIndicator() {
        indicator.stopAnimating()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func setTableTitle(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: leagesTable.bounds.width, height: 40))
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "Leagues"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        headerView.addSubview(titleLabel)
        leagesTable.tableHeaderView = headerView
    }
    func setTableBackgroundColor(){
        if let color=UIColor(named: "BackgroundColor"){
            leagesTable.backgroundColor=color
        }else{
            leagesTable.backgroundColor=UIColor.white
        }
    }
}

extension LeagesViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "detailsScreen") as? LeagueDetailsViewController {
            var image:String=""
            let favLeaguesViewModel=FavLeaguesViewModel()
            if let urlString = leagesViewModel?.getLeages()[indexPath.row].leagueLogo,
               let url = URL(string: urlString) {
                image=urlString
            } else {
                image = "leagueImage"
            }
            favLeaguesViewModel.currentLeague=FavLeaguesModel(leagueId: Int64((leagesViewModel?.getLeages()[indexPath.row].leagueKey)!), leagueLogo: image, leagueName: (leagesViewModel?.getLeages()[indexPath.row].leagueName)!)
            
            secondViewController.favLeaguesViewModel=favLeaguesViewModel
            let leagueDetailsViewModel = LeagueDetailsViewModel(networkService: NetworkService())
            leagueDetailsViewModel.leagueID=(leagesViewModel?.getLeages()[indexPath.row].leagueKey)!
            leagueDetailsViewModel.sportIndex=leagesViewModel?.getSportIndex() ?? 0
            secondViewController.leagueDetailsViewModel=leagueDetailsViewModel
            print("sportIndex: ",leagesViewModel?.getSportIndex() ?? 0)
            print("leagueId: ",(leagesViewModel?.getLeages()[indexPath.row].leagueKey)!)
            //leagueId,sportIndex
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
}
extension LeagesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagesViewModel?.getLeagesCount() ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leagesCell=tableView.dequeueNibCell(cellClass: LeagesTableViewCell.self)
        leagesCell.leageName.text=leagesViewModel?.getLeages()[indexPath.row].leagueName
        if let urlString = leagesViewModel?.getLeages()[indexPath.row].leagueLogo,
           let url = URL(string: urlString) {
            leagesCell.leageImage.kf.setImage(with: url, placeholder: UIImage(named: "leagueImage"))
        } else {
            leagesCell.leageImage.image = UIImage(named: "leagueImage")
        }
        return leagesCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
