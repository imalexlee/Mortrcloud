//
//  ForgotPassViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/11/21.
//

import UIKit
import Firebase

class ForgotPassViewController: UIViewController {
    
    @IBOutlet weak var forgotPassEmail: UITextField!
    
    @IBOutlet weak var sendEmailResetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let t:TextFieldHelper = TextFieldHelper()
        t.addPaddingAndBorder(to: forgotPassEmail)
        
        
        forgotPassEmail.layer.cornerRadius = 10.0
        forgotPassEmail.layer.borderWidth = 2.0
        forgotPassEmail.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 0.5).cgColor
        
        sendEmailResetButton.layer.cornerRadius = 25
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func xTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "introPage")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func sendEmailResetButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
        let a:AlertViewHelper = AlertViewHelper()
        auth.sendPasswordReset(withEmail: forgotPassEmail.text!) { (error) in
            if let error = error{
                print("error: \(error.localizedDescription)")
                a.createAlert(title: "Uh Oh", message: "Email wasn't found", in: self)
            }else{
                a.createAlert(title: "Email sent", message: "Click \"Send\" again if email doesn't appear within 3 minutes", in: self)
                print("password reset email sent successfully")
            }
        }
    }
}
