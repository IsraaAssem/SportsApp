//
//  LeagesTableViewCell.swift
//  SportsApp
//
//  Created by Israa Assem on 13/05/2024.
//

import UIKit

class LeagesTableViewCell: UITableViewCell {
    @IBOutlet weak var leageName: UILabel!
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var leageImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellBackgroundView.layer.cornerRadius=10
        self.cellBackgroundView.layer.borderColor=UIColor(named: "PrimaryColor")?.cgColor
        self.cellBackgroundView.layer.borderWidth=1
        leageImage.layer.cornerRadius = leageImage.frame.width / 2
        leageImage.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
