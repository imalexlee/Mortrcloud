//
//  LoginViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/3/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var userId = ""
    var e_mail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let t:TextFieldHelper = TextFieldHelper()
        t.addPaddingAndBorder(to: email)
        t.addPaddingAndBorder(to: password)
        
        email.layer.cornerRadius = 10.0
        email.layer.borderWidth = 2.0
        email.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 0.5).cgColor
        
        password.layer.cornerRadius = 10.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 0.5).cgColor
        
        loginButton.layer.cornerRadius = 25
    }
    @IBAction func loginTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func forgotPassTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "resetPass")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func xTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "introPage")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
    
    func validateFields(){
        let a:AlertViewHelper = AlertViewHelper()
        if email.text?.isEmpty == true || password.text?.isEmpty == true{
            print("No email or password text")
            a.createAlert(title: "Uh Oh", message: "No email or password text", in: self)
            return
        }
        
        login()
    }
    
    func login(){
        let a:AlertViewHelper = AlertViewHelper()
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, err in
            guard self != nil else {return}
            if let err = err{
                print("Error \(err.localizedDescription)")
                a.createAlert(title: "Uh Oh", message: "Email or Password is incorrect", in: self!)
            }
            if Auth.auth().currentUser != nil{
                let user = authResult?.user
                let db = Firestore.firestore()
                
                AchievementsHelper.getAchievements()
                
                GeneralHelper().retrieveStreakTime()
                
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
                    
                    if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                        let urlString = docSnapshot!.get("imageURL") as! String
                        UserDefaults.standard.set(urlString, forKey: Auth.auth().currentUser!.uid as String)
                        print("login default hit")
                    }
                }
                
                if let user = user {
                    
                    UserService.retrieveProfile(UserID:user.uid) { (user) in
                        
                        
                        let tabBarVC = self?.storyboard?.instantiateViewController(identifier: "homePage")
                        
                        guard tabBarVC != nil else {
                            return
                        }
                        self?.view.window?.rootViewController = tabBarVC
                        self?.view.window?.makeKeyAndVisible()
                        
                    }
                }
            }
        }
    }
}

