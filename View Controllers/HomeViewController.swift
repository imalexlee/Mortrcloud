//
//  HomeViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/5/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var currentCourseLabel: UILabel!
    @IBOutlet weak var currentLessonView: UIView!
    
    @IBOutlet weak var percentComplete: UILabel!
    @IBOutlet weak var completeView: UIView!
    
    @IBOutlet weak var dayCountView: UIView!
    @IBOutlet weak var streakLabel: UILabel!
    
    @IBOutlet weak var AchievementsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
 
    private let storage = Storage.storage().reference()
    
    var tableViewHeight = 0.0
    var indexArray:[Any] = []
    var didLayout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoalModel().retreiveGoals()
        
        let nib = UINib(nibName: "AchievementsTableViewCell", bundle: nil)
        AchievementsTableView.register(nib, forCellReuseIdentifier: "AchievementsTableViewCell")
        AchievementsTableView.delegate = self
        AchievementsTableView.dataSource = self
        
        completeView.layer.cornerRadius = 15
        completeView.layer.borderWidth = 0.9
        completeView.layer.borderColor = UIColor.black.cgColor
        dayCountView.layer.cornerRadius = 15
        dayCountView.layer.borderWidth = 0.9
        dayCountView.layer.borderColor = UIColor.black.cgColor
        currentLessonView.layer.cornerRadius = 15
        currentLessonView.layer.borderWidth = 0.9
        currentLessonView.layer.borderColor = UIColor.black.cgColor
        
        
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                self.usernameLabel.alpha = 0
                self.usernameLabel.text = docSnapshot!.get("username") as? String
                
                UIView.animate(withDuration: 1.3, delay: 0.7, options: .curveEaseIn, animations: {
                    self.usernameLabel.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        
        
        if UserDefaults.standard.value(forKey: Auth.auth().currentUser!.uid as String) == nil {
            print("Defaults not ready")
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
                
                if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                    print("home page default hit")
                    
                    let urlString = docSnapshot!.get("imageURL") as! String
                    UserDefaults.standard.set(urlString, forKey: Auth.auth().currentUser!.uid as String)
                    
                }
            }
        }
        
        guard let urlString = UserDefaults.standard.value(forKey: Auth.auth().currentUser!.uid as String) as? String,
              let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.profilePic.alpha = 0
                let image = UIImage(data: data)
                self.profilePic.layer.cornerRadius = self.profilePic.frame.width / 2
                self.profilePic.clipsToBounds = true
                self.profilePic.image = image
                
                UIView.animate(withDuration: 1.3, delay: 0, options: .curveEaseIn, animations: {
                    self.profilePic.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        })
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for x in 0...5{
                let cell = AchievementsTableView.cellForRow(at: indexArray[x] as! IndexPath)
                tableViewHeight += Double(cell!.contentView.frame.height)
            }
        print("table view height = \(tableViewHeight)" )
        tableViewHeightConstraint.constant = CGFloat(tableViewHeight)
        tableViewHeight = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        AchievementsTableView.reloadData()
        
        GeneralHelper().setTotal()
        
        GeneralHelper().checkTime()
        
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                let percent = Int((((docSnapshot!.get("totalComplete") as! Double)/24) * 100).rounded(.up))
                self.percentComplete.text = (String)(percent) + "%"
                AchievementsHelper.increaseCompletion(percent)
                
                UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseIn, animations: {
                    //self.currentLessonLabel.alpha = 0
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        currentCourseLabel.text = GeneralHelper.courseLabel[GeneralHelper.currentCourseIndex]
    }
    
    @IBAction func editImageTapped(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        
        storage.child("images/\(Auth.auth().currentUser!.uid as String).png").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("images/\(Auth.auth().currentUser!.uid as String).png").downloadURL { url, error in
                
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: Auth.auth().currentUser!.uid as String)
                let db = Firestore.firestore()
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
                    
                    if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                        
                        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["imageURL" : urlString], merge: true)
                        
                    }
                }
                DispatchQueue.main.async {
                    self.profilePic.image = image
                }
            }
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayout {
            
            GeneralHelper().streakTime()
            let defaults = UserDefaults.standard
            let streak = defaults.integer(forKey: "streak")
            self.streakLabel.text = (String)(streak)
            AchievementsHelper.increaseStreak(streak)
            didLayout = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsTableViewCell") as! AchievementsTableViewCell
        let defaults = UserDefaults.standard
        let array = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        cell.achievementsImage.image = UIImage(named: "award\(indexPath.row)")
        cell.achievementsCellLabel.text = AchievementsHelper.header["title\(indexPath.row)"]
        cell.achievementsCellDescription.text = AchievementsHelper.header["description\(indexPath.row)"]
        cell.achievementsCellProgressView.progress = Float(array["currentNum\(indexPath.row)"]!)/Float(array["finalNum\(indexPath.row)"]!)
        let frac = array["currentNum\(indexPath.row)"]! / array["finalNum\(indexPath.row)"]!
        if frac < 1 {
            cell.checkImage.alpha = 0
            cell.achivementsCellProgressLabel.alpha = 1
            cell.achivementsCellProgressLabel.text = "\(array["currentNum\(indexPath.row)"] ?? 0)/\(array["finalNum\(indexPath.row)"] ?? 0)"
        } else {
            cell.checkImage.alpha = 1
            cell.achivementsCellProgressLabel.alpha = 0
            
        }
        
        indexArray.append(indexPath)
        return cell
    }
}
