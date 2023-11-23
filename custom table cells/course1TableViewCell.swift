//
//  course1TableViewCell.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/13/21.
//

import UIKit

class course1TableViewCell: UITableViewCell {

    @IBOutlet weak var course1LeftLabel: UILabel!
    
    @IBOutlet weak var course1LessonCellLabel: UILabel!
    
    @IBOutlet weak var completeImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
