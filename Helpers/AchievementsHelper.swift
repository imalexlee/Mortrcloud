//
//  AchievementsHelper.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/19/21.
//

import Foundation
import Firebase
import FirebaseAuth
class AchievementsHelper{
    
   public static let header = ["title0":"Book Worm","description0":"Read 3 Articles","title1":"Driven","description1":"Create 4 Goals","title2":"Scholar","description2":"Take 3 Quizes","title3":"Consistent","description3":"Get a 3 Day Streak","title4":"Completionist","description4":"Obtain 100% completion","title5":"Dedicated","description5":"Complete a Course"]
    
    public static func increaseArticleRead(_ pos:Int){
        
        let defaults = UserDefaults.standard
        var array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        if  array["currentNum0"] ?? 3 < 3 {
            let courseArray:[Any]
            switch GeneralHelper.currentCourseIndex{
            case 0:
                courseArray = GeneralHelper.course0complete
            case 1:
                courseArray = GeneralHelper.course1complete
            case 2:
                courseArray = GeneralHelper.course2complete
            case 3:
                courseArray = GeneralHelper.course3complete
            default:
                print("unable to set courseArray")
                courseArray = [1,1,1,1,1,1,1]
            }
            if courseArray[pos] as! Int == 0{
                array["currentNum0"]? += 1
                //courseArray[pos] = 1
                
                defaults.set(array, forKey: "achievementsArray")
                updateAchievements()
            }
        }
    }
    
    public static func increaseGoalMade(){
        let defaults = UserDefaults.standard
        var array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        if  array["currentNum1"] ?? 4 < 4 {
            
            array["currentNum1"]? += 1
            
            defaults.set(array, forKey: "achievementsArray")
            updateAchievements()
        }
    }
  
    
    public static func increaseQuizTaken(_ pos:Int){
        let defaults = UserDefaults.standard
        var array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        if  array["currentNum2"] ?? 3 < 3 {
            let courseArray:[Any]
            switch GeneralHelper.currentCourseIndex{
            case 0:
                courseArray = GeneralHelper.course0complete
            case 1:
                courseArray = GeneralHelper.course1complete
            case 2:
                courseArray = GeneralHelper.course2complete
            case 3:
                courseArray = GeneralHelper.course3complete
            default:
                print("unable to set courseArray")
                courseArray = [1,1,1,1,1,1,1]
            }
            if courseArray[pos] as! Int == 0{
                array["currentNum2"]? += 1
                //courseArray[pos] = 1
                
                defaults.set(array, forKey: "achievementsArray")
                updateAchievements()
            }
        }
    }
    
    
    public static func increaseStreak(_ day:Int){
        let defaults = UserDefaults.standard
        var array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        if  array["currentNum3"] ?? 3 < 3 {
            
            array["currentNum3"]? = day
            
            defaults.set(array, forKey: "achievementsArray")
            updateAchievements()
        }
    }
    
    public static func increaseCompletion(_ percent:Int){
        let defaults = UserDefaults.standard
        var array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        if  percent == 100 {
            
            array["currentNum4"]? = 1
            
            defaults.set(array, forKey: "achievementsArray")
            updateAchievements()
        }
    }
    
    public static func completedCourse(){
        let defaults = UserDefaults.standard
        var array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        var sum = 0
        if  array["currentNum5"] ?? 1 < 1 {
            let courseArray:[Any]
            switch GeneralHelper.currentCourseIndex{
            case 0:
                courseArray = GeneralHelper.course0complete
            case 1:
                courseArray = GeneralHelper.course1complete
            case 2:
                courseArray = GeneralHelper.course2complete
            case 3:
                courseArray = GeneralHelper.course3complete
            default:
                print("unable to set courseArray")
                courseArray = [0,0,0,0,0,0,0]
            }
            for value in courseArray{
                sum += value as! Int
            }
            if sum > 5 {
                array["currentNum5"] = 1
                //courseArray[pos] = 1
                
                defaults.set(array, forKey: "achievementsArray")
                updateAchievements()
            }
        }
    }
    
    public static func updateAchievements(){
        let db = Firestore.firestore()
        let reference = db.collection("achievements").document(Auth.auth().currentUser!.uid)
        let defaults = UserDefaults.standard
        let array:[String:Int] = defaults.object(forKey: "achievementsArray") as? [String:Int] ?? [:]
        reference.getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                db.collection("achievements").document(Auth.auth().currentUser!.uid).setData([
                    "achievementsArray":array
                ])
            }
        }
    }
    
    public static func getAchievements(){
        let db = Firestore.firestore()
        db.collection("achievements").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                var array:[String:Int] = [:]
                let defaults = UserDefaults.standard
                
                array = docSnapshot!.get("achievementsArray") as! [String:Int]
                
                defaults.set(array, forKey: "achievementsArray")
                
            }
        }
    }
}
