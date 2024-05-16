//
//  TeamsCollectionViewCell.swift
//  SportsApp
//
//  Created by Israa Assem on 14/05/2024.
//

import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var teamImage: UIImageView!

        override func layoutSubviews() {
            super.layoutSubviews()
            teamImage.frame=contentView.bounds
            teamImage.layer.masksToBounds=true
            teamImage.layer.cornerRadius = teamImage.frame.size.width / 2
            teamImage.layoutIfNeeded()
             teamImage.contentMode = .scaleAspectFill
            teamImage.clipsToBounds = true
            teamImage.layer.borderWidth=0.5
            teamImage.layer.borderColor=UIColor(named: "PrimaryColor")?.cgColor
        }
}
