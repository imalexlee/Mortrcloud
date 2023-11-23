//
//  GoalModel.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class GoalModel{
    
    public static var GoalArray:[[String:Any]] = []
    
    func retreiveGoals(){
        let db = Firestore.firestore()
        let reference = db.collection("Goals").document(Auth.auth().currentUser!.uid)
        reference.getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                let Goals = docSnapshot?.data()?["GoalArray"] as! [[String : Any]]
                for Goalz in Goals{
                    GoalModel.GoalArray.append(Goalz)
                }
                
                print(GoalModel.GoalArray)
//                reference.updateData(["GoalArray" : FieldValue.arrayUnion([[
//                    "GoalTitle": "Title text heree",
//                    "GoalNote": "Note text heree"
//                ]])
//                ])
            }
        }
    }
}
