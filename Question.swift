//
//  Question.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/14/21.
//

import Foundation
struct Question: Codable{
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
}
