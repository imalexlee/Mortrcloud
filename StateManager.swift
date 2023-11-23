//
//  StateManager.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/15/21.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "NumberCorrectKey"
    static var questionIndexKey = "questionIndexKey"
    
    static func saveState(numCorrect:Int, questionIndex:Int){
        
        //get a reference to defaults
        let defaults = UserDefaults.standard
        
        //save state data
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
        
    }
    
    static func retrieveValue(key:String) -> Any?{
        let defaults = UserDefaults.standard
        
        return defaults.value(forKey: key)
    }
    
    static func clearState(){
        let defaults = UserDefaults.standard
        
        //clear state data in defaults
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
    }
}
