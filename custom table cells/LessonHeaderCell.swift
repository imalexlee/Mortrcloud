//
//  LessonHeaderCell.swift
//  mortrcloud
//
//  Created by Alex Lee on 5/31/21.
//

import UIKit

class LessonHeaderCell: UITableViewCell {

    @IBOutlet weak var LessonHeaderTitle: UILabel!
    
    @IBOutlet weak var LessonHeaderSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
