//
//  LeagesTableViewCell.swift
//  SportsApp
//
//  Created by Israa Assem on 13/05/2024.
//

import UIKit

class LeagesTableViewCell: UITableViewCell {
    @IBOutlet weak var leageName: UILabel!
    
    @IBOutlet weak var leageImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius=10
        self.layer.borderColor=UIColor.black.cgColor
        self.layer.borderWidth=1
        leageImage.layer.cornerRadius = leageImage.bounds.width / 2
        leageImage.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
