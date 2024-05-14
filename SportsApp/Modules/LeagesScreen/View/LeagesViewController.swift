//
//  LeagesViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 13/05/2024.
//

import UIKit
import Kingfisher
class LeagesViewController: UIViewController {
    var sportIndex=0
    @IBOutlet weak var leagesTable: UITableView!
    var leagesViewModel:LeagesViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        leagesTable.delegate=self
        leagesTable.dataSource=self
        setTableTitle()
        setTableBackgroundColor()
        leagesViewModel=LeagesViewModel(networkService: NetworkService())
        leagesViewModel?.bindLeagesToViewController={[weak self] in
            DispatchQueue.main.async{
                self?.leagesTable.reloadData()
            }
        }
        leagesViewModel?.fetchLeages(sportIndex:sportIndex)
        leagesTable.registerNib(cell: LeagesTableViewCell.self)
        
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
    
}
extension LeagesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagesViewModel?.getLeagesCount() ?? 0
        //return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leagesCell=tableView.dequeueNibCell(cellClass: LeagesTableViewCell.self)
        leagesCell.leageName.text=leagesViewModel?.getLeages()[indexPath.row].leagueName
        if let urlString = leagesViewModel?.getLeages()[indexPath.row].leagueLogo,
           let url = URL(string: urlString) {
            leagesCell.leageImage.kf.setImage(with: url, placeholder: UIImage(named: "loadingPlaceholder"))
        } else {
            leagesCell.leageImage.image = UIImage(named: "loadingPlaceholder")
        }
        //leagesCell.leageImage.image = UIImage(named: "loadingPlaceholder")
        //leagesCell.leageName.text="Israa Assem Mohamed"
        return leagesCell
    }
    
    
}
