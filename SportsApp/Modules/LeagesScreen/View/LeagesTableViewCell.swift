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
        //        let inset: CGFloat = 10
        //           contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0))
        //
        //           contentView.layer.cornerRadius = 10
        //           contentView.layer.borderColor = UIColor.black.cgColor
        //           contentView.layer.borderWidth = 1
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
