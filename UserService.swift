//
//  UserService.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/16/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService{
    
    static func createProfile(userID:String, username:String, completion: @escaping (appUser?) -> Void){
        
        let defaults = UserDefaults.standard
        var achievementsArray:[String:Int] = [:]
        achievementsArray = ["currentNum0":0,"finalNum0":3,"currentNum1":0,"finalNum1":4,"currentNum2":0,"finalNum2":3,"currentNum3":0,"finalNum3":3,"currentNum4":0,"finalNum4":1,"currentNum5":0,"finalNum5":1]
        
        print("defaults 1 size: \(achievementsArray.count)")
        let currTime = Date.init()
        let currStreak = Date.init()
        defaults.set(currStreak, forKey: "streakTime")
        defaults.set(currTime, forKey: "currTime")
        defaults.set(achievementsArray, forKey: "achievementsArray")
        defaults.set(0, forKey: "articlesRead")
        
        var u = appUser()
        let db = Firestore.firestore()
        
        db.collection("Goals").document(userID).setData([
            "GoalArray":[[String:Any]]()
        ])
        
        db.collection("achievements").document(userID).setData([
            "achievementsArray":achievementsArray
        ])
        
        db.collection("users").document(userID).setData([
            "username": username,
            "courseTitleX":0,
            "courseTitleY":0,
            "totalComplete":0,
            "imageURL":"",
            "currTime":Timestamp(date: Date()),
            "streakTime":Timestamp(date: Date()),
            "timeSinceUpdateStreak":Timestamp(date: Date()),
            "time": Timestamp(date: Date()),
            "course0complete": [0,0,0,0,0,0,0],
            "course1complete": [0,0,0,0,0,0,0],
            "course2complete": [0,0,0,0,0,0,0],
            "course3complete": [0,0,0,0,0,0,0]
        ]) { err in
            if err != nil{
                completion(nil)
            } else {
                u.username = username
                completion(u)
            }
        }
    }

    static func retrieveProfile(UserID: String, completion: @escaping (appUser?) -> Void){
        
        //get a firestore reference
        let db = Firestore.firestore()
        
        //check for a profile, given a user id
        db.collection("users").document(UserID).getDocument { (snapshot, error) in
            if error != nil || snapshot == nil{
                print("error retrieving user")
                return
            }
            
            if let profile = snapshot!.data(){
                //profile was found, create a new appUser
                
                var u = appUser()
                u.userId = snapshot!.documentID
                u.username = profile["username"] as? String
                
                //return the user
                completion(u)
            } else {
                // couldn't get profile, no profile
                //return nil
                completion(nil)
            }
        }
    }
}
