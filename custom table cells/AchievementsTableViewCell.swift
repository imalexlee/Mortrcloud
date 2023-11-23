//
//  AchievementsTableViewCell.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/18/21.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {
    @IBOutlet weak var achievementsCellLabel: UILabel!
    
    @IBOutlet weak var achievementsCellDescription: UILabel!
    
    @IBOutlet weak var achievementsCellProgressView: UIProgressView!
    
    @IBOutlet weak var achivementsCellProgressLabel: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var achievementsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
