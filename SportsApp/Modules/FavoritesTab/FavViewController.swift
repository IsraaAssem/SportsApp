//
//  FavViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 11/05/2024.
//

import UIKit

class FavViewController: UIViewController {
    
    @IBOutlet weak var favLeaguesTable: UITableView!
    
    var favViewModel:FavLeaguesViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        favViewModel=FavLeaguesViewModel()
        favLeaguesTable.delegate=self
        favLeaguesTable.dataSource=self
        setTableTitle()
        setTableBackgroundColor()        
        favViewModel.bindFavLeagesToViewController={[weak self] in
            DispatchQueue.main.async{
                self?.favLeaguesTable.reloadData()
            }
        }
        
        favLeaguesTable.registerNib(cell: LeagesTableViewCell.self)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favViewModel.retrieveStoredFavLeagues()
    }
    init(favViewModel: FavLeaguesViewModelProtocol!) {
        self.favViewModel = favViewModel
        super.init(nibName: "LeagesTableViewCell", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func setTableTitle(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: favLeaguesTable.bounds.width, height: 40))
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "Leagues"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        headerView.addSubview(titleLabel)
        favLeaguesTable.tableHeaderView = headerView

    }
    func setTableBackgroundColor(){
        if let color=UIColor(named: "BackgroundColor"){
            favLeaguesTable.backgroundColor=color
        }else{
            favLeaguesTable.backgroundColor=UIColor.white
        }
    }
    
}
extension FavViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favViewModel.getFavLeagesArrCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leagesCell=tableView.dequeueNibCell(cellClass: LeagesTableViewCell.self)
        leagesCell.leageName.text=favViewModel?.getFavLeaguesArr()[indexPath.row].leagueName
        if let urlString = favViewModel?.getFavLeaguesArr()[indexPath.row].leagueLogo,
           let url = URL(string: urlString) {
            leagesCell.leageImage.kf.setImage(with: url, placeholder: UIImage(named: "loadingPlaceholder"))
        } else {
            leagesCell.leageImage.image = UIImage(named: "loadingPlaceholder")
        }
        return leagesCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension FavViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction:UITableViewRowAction=UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete League", handler: {_,_  in
            let deleteAlert=UIAlertController(title: "Delete League", message: "Are you sure you want to delete this league from favorites?", preferredStyle: UIAlertController.Style.alert)
            let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { _  in
                self.favViewModel.deleteFromFavLeagues(league: self.favViewModel.getFavLeaguesArr()[indexPath.row])
            })
            let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
            
        })
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "detailsScreen") as? LeagueDetailsViewController {
            
            let leagueDetailsViewModel = LeagueDetailsViewModel(networkService: NetworkService())
            leagueDetailsViewModel.leagueID=Int((favViewModel?.getFavLeaguesArr()[indexPath.row].leagueId)!)
            leagueDetailsViewModel.sportIndex = 0
            secondViewController.leagueDetailsViewModel=leagueDetailsViewModel
            favViewModel.setCurrentLeague(league: (favViewModel?.getFavLeaguesArr()[indexPath.row])!)
            secondViewController.favLeaguesViewModel=favViewModel
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
}
