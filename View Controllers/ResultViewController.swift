//
//  ResultViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/15/21.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
    func nextArticleCalled()
    func exitTapped()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var exitButton: UIButton!
    
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    var nextArticleText = "Next Article"
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        dimView.alpha = 0
        titleLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fade in dimView
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        //fade out dim view
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.dimView.alpha = 0
        } completion: { (completed) in
            self.dismiss(animated: true, completion: nil)
            
            //notify delegate the popup was dismissed
            self.delegate?.dialogDismissed()
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        //fade out dim view
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.dimView.alpha = 0
        } completion: { (completed) in
            self.dismiss(animated: true, completion: nil)
            
            //notify delegate the popup was dismissed
            self.delegate?.exitTapped()
        }
    }
}
