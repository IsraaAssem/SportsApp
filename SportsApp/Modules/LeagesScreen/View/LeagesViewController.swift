//
//  LeagesViewController.swift
//  SportsApp
//
//  Created by Israa Assem on 13/05/2024.
//

import UIKit

class LeagesViewController: UIViewController {

    @IBOutlet weak var leagesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        leagesTable.delegate=self
        leagesTable.dataSource=self
        if let color=UIColor(named: "BackgroundColor"){
            leagesTable.backgroundColor=color
        }else{
            leagesTable.backgroundColor=UIColor.white
        }
        leagesTable.registerNib(cell: LeagesTableViewCell.self)
    }
    


}
extension LeagesViewController:UITableViewDelegate{
    
}
extension LeagesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leagesCell=tableView.dequeueNibCell(cellClass: LeagesTableViewCell.self)
        return leagesCell
    }
    
    
}
