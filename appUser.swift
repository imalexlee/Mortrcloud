//
//  appUser.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/16/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct appUser {
    
    var userId = Auth.auth().currentUser?.uid
    var username:String?
    var courseTitleX:Int?
    var courseTitleY:Int?
}
