//
//  TextFieldHelper.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/15/21.
//

import Foundation
import UIKit

class TextFieldHelper: UITextField {
    
    func addPaddingAndBorder(to textfield: UITextField) {
        textfield.layer.cornerRadius =  5
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 1
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
}
