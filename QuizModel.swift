//
//  QuizModel.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/14/21.
//

import Foundation

protocol QuizProtocol {
    
    func questionsRetrieved(_ question:[Question])
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions(_ fileName:String){
        // fetch ques
        getLocalJsonFile(fileName)
        
    }
    
    func getLocalJsonFile(_ fileName:String){
        
        //get bundle path of json file
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        
        //check path isn't nil
        guard path != nil else {
            print("Couldn't find the json file")
            return
        }
        
        //create URL object from the path
        let url = URL(fileURLWithPath: path!)
        do {
            //get the data from the url
            let data = try Data(contentsOf: url)
            
            //try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            //notify the delegate of the parsed objects
            delegate?.questionsRetrieved(array)
        } catch {
            //couldn't read data from url
        }
    }
}
