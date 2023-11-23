//
//  SignUpViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/3/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        
        let t:TextFieldHelper = TextFieldHelper()
        t.addPaddingAndBorder(to: email)
        t.addPaddingAndBorder(to: password)
        t.addPaddingAndBorder(to: name)
        super.viewDidLoad()
        name.layer.cornerRadius = 10.0
        name.layer.borderWidth = 2.0
        name.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 0.5).cgColor
        
        email.layer.cornerRadius = 10.0
        email.layer.borderWidth = 2.0
        email.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 0.5).cgColor
        
        password.layer.cornerRadius = 10.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 0.5).cgColor
        
        signUpButton.layer.cornerRadius = 25
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let a:AlertViewHelper = AlertViewHelper()
        if email.text?.isEmpty == true ||  password.text?.isEmpty == true || name.text?.isEmpty == true{
            print("empty fields")
            a.createAlert(title: "Uh Oh", message: "empty fields", in: self)
            return
        } 
        signUp()
    }
    
    @IBAction func alreadyHaveAnAccountLoginTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func xTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "introPage")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func signUp(){
        let a:AlertViewHelper = AlertViewHelper()
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            guard authResult?.user != nil, error == nil else{
                print("Error: \(String(describing: error?.localizedDescription))")
                a.createAlert(title: "Uh Oh", message: "Email or password does not fit requirements", in: self)
                return
            }
            let username = self.name.text
            
            UserService.createProfile(userID: Auth.auth().currentUser!.uid, username: username!) { (user) in
                
                if user != nil{
                    
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: "homePage")
                    let urlString = "https://firebasestorage.googleapis.com/v0/b/mortrcloud-7bef5.appspot.com/o/images%2Ffile.png?alt=media&token=c419ba97-ec3c-4b13-bb3e-aec4c9ef73b4"
                    UserDefaults.standard.set(urlString, forKey: Auth.auth().currentUser!.uid as String)
                    let db = Firestore.firestore()
                    db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
                        
                        if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                            
                            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["imageURL" : urlString], merge: true)
                            
                        }
                    }
                    guard tabBarVC != nil else {
                        return
                    }
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                }
                else {
                    
                }
            }
        }
    }
}
