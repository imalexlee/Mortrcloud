//
//  GoalsCell.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/10/21.
//

import UIKit

class GoalsCell: UITableViewCell {
    @IBOutlet weak var GoalTitle: UILabel!
    
    @IBOutlet weak var GoalSubtitle: UILabel!
    
    @IBOutlet weak var MasteryLabel: UILabel!
    
    @IBOutlet weak var masteryStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
