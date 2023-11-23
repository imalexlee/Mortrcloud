//
//  GeneralHelper.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/17/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class GeneralHelper {
    public static var quizNum:Int = 0
    public static var x:Int = 0
    public static var currentJsonName:String = ""
    public static var currentCourseIndex:Int = 0
    public static var currentArticleIndex:Int = 0
    public static var courseTitles:[[String]] = [["","Don't interrupt","Don't interrupt: Quiz","Give relevant responses","Give relevant responses: Quiz","Shifting the conversation to you","Shifting the conversation to you: Quiz"],
                                                 ["","Validity","Validity: Quiz","Being vulnerable","Being vulnerable: Quiz","Telling others their faults","Telling others their faults: Quiz"],
                                                 ["","How not to ask","How not to ask: Quiz","How to ask","How to ask: Quiz","Reasonable requests","Reasonable requests: Quiz"],
                                                 ["","Taking in personal","Taking in personal: Quiz","Understanding intention","Understanding intention: Quiz","Understanding judgements","Understanding judgements: Quiz"]]
    
    public static var hints:[String] = ["Body language is a big part of communication", "Maintain good eye contact", "Try to stay on topic when someone's speaking", "Your thoughts are valid", "Speak like how you want to be spoken to", "Ask for change politely", "Develop fair judgements", "Respond relevantly", "Think of the intention behind words"]
    
    public static var headers:[String] = ["If you have a hard time engaging in conversations or you find yourself shifting attention in a discussion, focusing on active listening can help your conversations stay on track and allow both you and the other person to be heard.", "If you struggle with feelings of your emotions not being valid that cause you to put up walls, practicing putting your own feelings forward will help alleviate some of the doubts you place on yourself.", "If you feel that asking others for something you want is demanding, or that you should get over things if they bother you, practicing the skills involved with speaking up about how you feel can help you overcome those reservations.", "If you find yourself judging a situation or person before you fully understand context and intention, working on developing compassionate judgements can help you think fairly and calmly in any scenario."]
    
    public static var course0complete:[Any] = []
    public static var course1complete:[Any] = []
    public static var course2complete:[Any] = []
    public static var course3complete:[Any] = []
    
    public static var courseSubtitle = ["Build your ability to listen to others more effectively", "Let your feelings be heard by others", "Put your emotions into action", "View situations fairly"]
    public static var courseLabel = ["Active Listening", "Putting forth your own feelings", "Speaking on what you want and need", "Develop compasionate judgements"]
    
    public static var totalComplete:Int = 0
        
    func setArray(_ course:Int, _ lesson:Int){

        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                switch course {
                case 0:
                    GeneralHelper.course0complete = docSnapshot!.get("course0complete") as! [Any]
                    GeneralHelper.course0complete[lesson] = 1
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["course0complete" : GeneralHelper.course0complete], merge: true)
                case 1:
                    GeneralHelper.course1complete = docSnapshot!.get("course1complete") as! [Any]
                    GeneralHelper.course1complete[lesson] = 1
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["course1complete" : GeneralHelper.course1complete], merge: true)
                case 2:
                    GeneralHelper.course2complete = docSnapshot!.get("course2complete") as! [Any]
                    GeneralHelper.course2complete[lesson] = 1
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["course2complete" : GeneralHelper.course2complete], merge: true)
                case 3:
                    GeneralHelper.course3complete = docSnapshot!.get("course3complete") as! [Any]
                    GeneralHelper.course3complete[lesson] = 1
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["course3complete" : GeneralHelper.course3complete], merge: true)
                default:
                    print("couldn't change firestore array")
                }
                AchievementsHelper.completedCourse()
            }
        }
    }
    
    func setTotal(){

        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                var total = 0
                
                GeneralHelper.course0complete = docSnapshot!.get("course0complete") as! [Any]
                GeneralHelper.course1complete = docSnapshot!.get("course1complete") as! [Any]
                GeneralHelper.course2complete = docSnapshot!.get("course2complete") as! [Any]
                GeneralHelper.course3complete = docSnapshot!.get("course3complete") as! [Any]
                
                for number in GeneralHelper.course0complete {
                    total += number as! Int
                }
                for number in GeneralHelper.course1complete {
                    total += number as! Int
                }
                for number in GeneralHelper.course2complete {
                    total += number as! Int
                }
                for number in GeneralHelper.course3complete {
                    total += number as! Int
                }
                
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["totalComplete" : total], merge: true)
                                
            }
        }
    }
    
    func timeUpdate(){
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["time" : Timestamp(date: Date())], merge: true)
            }
        }
    }
    
    func checkTime(){
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                let time0 = Timestamp.dateValue(docSnapshot!.get("time") as! Timestamp)
                let date = Date.init()
                //print(date.timeIntervalSince(time0()))
                
                if date.timeIntervalSince(time0()) > 86400 {
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["dayStreak" : 0], merge: true)
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["timeSinceUpdateStreak" : Timestamp(date: Date())], merge: true)
                    self.timeUpdate()
                    return
                }
                self.timeUpdate()
            }
        }
    }
    
    func streakTime(){
        let defaults = UserDefaults.standard
        let time1 = defaults.object(forKey: "currTime") as! Date
        let streak = defaults.object(forKey: "streakTime") as! Date
        let date = Date.init()
        let num1 = date.timeIntervalSince(time1)
        
        
        if num1 < 86400 {
            let num2 = date.timeIntervalSince(streak)
            let newStreak = Int(((num2)/86400).rounded(.down))
            defaults.set(newStreak, forKey: "streak")
        } else {
            defaults.setValue(0, forKey: "streak")
            defaults.setValue(date, forKey: "streakTime")
        }
        defaults.set(date, forKey: "currTime")
        self.setStreakTime()
    }
    
    func retrieveStreakTime(){
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                let defaults = UserDefaults.standard
                
                let currentTime = (docSnapshot!.get("currTime") as! Timestamp).dateValue()
                let streakTime = (docSnapshot!.get("streakTime") as! Timestamp).dateValue()
                
                defaults.set(currentTime, forKey: "currTime")
                defaults.set(streakTime, forKey: "streakTime")
                
            }
        }
    }
    
    func setStreakTime(){
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                let currTime = UserDefaults.standard.object(forKey: "currTime") as! Date
                let streakTime = UserDefaults.standard.object(forKey: "streakTime") as! Date
                    
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["currTime" : Timestamp(date: currTime)], merge: true)
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["streakTime" : Timestamp(date: streakTime)], merge: true)
      }
    }
  }
}
