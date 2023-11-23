//
//  IntroViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class IntroViewController: UIViewController {
    
    @IBOutlet weak var introLogIn: UIButton!
    
    @IBOutlet weak var introSignUp: UIButton!
    
    var didCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        introSignUp.layer.cornerRadius = 25
        introSignUp.layer.borderWidth = 2
        introSignUp.layer.borderColor = UIColor.black.cgColor
        checkUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        didCheck = false
    }
    
    override func viewDidLayoutSubviews() {
        if !didCheck{
            checkUserInfo()
            didCheck = true
        }
    }
    
    
    @IBAction func introLogInTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func introSignUpTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    func checkUserInfo(){
        if Auth.auth().currentUser != nil {
            let tabBarVC = self.storyboard?.instantiateViewController(identifier: "homePage")
            
            let defaults = UserDefaults.standard
            if defaults.object(forKey: "currTime") as? Date == nil {
                defaults.set(Date.init(), forKey: "currTime")
            }
            if defaults.object(forKey: "streakTime") as? Date == nil {
                defaults.set(Date.init(), forKey: "streakTime")
            }
            
            guard tabBarVC != nil else {
                return
            }
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
                
                if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                    let urlString = docSnapshot!.get("imageURL") as! String
                    UserDefaults.standard.set(urlString, forKey: Auth.auth().currentUser!.uid as String)
                    print("intro default hit")
                    
                }
            }
            
            self.view.window?.rootViewController = tabBarVC
            self.view.window?.makeKeyAndVisible()
        }
    }
}
