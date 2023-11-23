//
//  CoursesTableViewCell.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/9/21.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    
    @IBOutlet weak var courseTitle: UILabel!
    
    @IBOutlet weak var courseSubtitle: UILabel!
    @IBOutlet weak var courseIconImage: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        courseImage.layer.cornerRadius = 15
        courseImage.clipsToBounds = true
        courseImage.layer.borderColor = UIColor.white.cgColor
        courseImage.layer.borderWidth = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
