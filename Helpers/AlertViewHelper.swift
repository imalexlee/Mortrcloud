//
//  AlertViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/13/21.
//

import UIKit

class AlertViewHelper: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    public func createAlert(title:String, message:String, in vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }

}

