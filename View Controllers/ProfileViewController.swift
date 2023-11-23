//
//  ProfileViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/5/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GeneralHelper().checkTime()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "introPage")
            GoalModel.GoalArray.removeAll()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            return
        }
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Account", message: "Enter E-mail and password to delete account", preferredStyle: UIAlertController.Style.alert )
        
        let save = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            let user = Auth.auth().currentUser
            var credential: AuthCredential
            
            credential = EmailAuthProvider.credential(withEmail: textField.text!, password: textField2.text!)
            user?.reauthenticate(with: credential, completion: { (result, error) in
                if let err = error {
                    print("Error: \(err.localizedDescription)")
                } else {
                    
                    user?.delete { error in
                        if let error = error {
                            
                            print("Error: \(error.localizedDescription)")
                            
                        } else {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(identifier: "introPage")
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true)
                        }
                    }
                }
            })
        }
        
        
        alert.addTextField { (textField) in
            textField.placeholder = "E-mail"
            textField.textColor = .black
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.textColor = .black
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        alert.addAction(save)
        
        self.present(alert, animated:true, completion: nil)
    }
}
