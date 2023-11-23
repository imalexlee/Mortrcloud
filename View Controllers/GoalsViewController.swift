//
//  GoalsViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateGoalDelegate{
    
    
    func didTapButtons() {
        GoalsTableView.reloadData()
        reloadNoGoal()
    }
    

    @IBOutlet weak var addGoalButton: UIButton!
    
    @IBOutlet weak var GoalsTableView: UITableView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var noGoalsView: UILabel!
    var currIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoalsTableView.dataSource = self
        GoalsTableView.delegate = self
        addGoalButton.contentVerticalAlignment = .fill
        addGoalButton.contentHorizontalAlignment = .fill     
        
        let nib = UINib(nibName: "GoalsCell", bundle: Bundle.main)
        GoalsTableView.register(nib, forCellReuseIdentifier: "GoalsCell")
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalModel.GoalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GoalsTableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalsCell
        cell.GoalTitle.text = (GoalModel.GoalArray[indexPath.row])["GoalTitle"] as? String
        cell.GoalSubtitle.text = (GoalModel.GoalArray[indexPath.row])["GoalNote"] as? String
        cell.MasteryLabel.text = String.init(describing: (GoalModel.GoalArray[indexPath.row])["masteryNum"] as? Int ?? 0)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoalsTableView.reloadData()
        reloadNoGoal()
    }

    @IBAction func addTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "createGoal") as! CreateGoalViewController
        vc.GoalDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditGoalViewController
        
        let goalGroup = GoalModel.GoalArray[currIndex]
        let passedTitle = goalGroup["GoalTitle"] as? String
        let passedNote = goalGroup["GoalNote"] as? String
        let passedPos = goalGroup["masteryNum"] as? Int ?? 0
        vc.cellIndex = currIndex
        vc.receivedTitle = passedTitle!
        vc.receivedNote = passedNote!
        vc.sliderPos = passedPos
    }
    
    //MARK: leads to edit goal view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currIndex = indexPath.row
        
        performSegue(withIdentifier: "editGoalSegue", sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        GoalsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            GoalModel.GoalArray.remove(at: indexPath.row)
            GoalsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            let db = Firestore.firestore()
            let reference = db.collection("Goals").document(Auth.auth().currentUser!.uid)
            //let cell = GoalsTableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalsCell
            
            reference.getDocument { (docSnapshot, error) -> Void in
                
                if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                    
                   
                    reference.setData([
                        "GoalArray": GoalModel.GoalArray
                    ])
                }
            }
            
            reloadNoGoal()
        }
    }
    
    func reloadNoGoal(){
        if GoalModel.GoalArray.count > 0{
            noGoalsView.alpha = 0
            
        } else{
            noGoalsView.alpha = 1
        }
    }
}
 
