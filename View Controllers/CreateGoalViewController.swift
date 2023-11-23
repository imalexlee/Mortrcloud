//
//  CreateGoalViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import EventKit
import EventKitUI

protocol CreateGoalDelegate {
    func didTapButtons()
}


class CreateGoalViewController: UIViewController, EKEventViewDelegate,UINavigationControllerDelegate, EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var GoalTextView: UITextView!
    
    @IBOutlet weak var NoteTextView: UITextView!
    
    @IBOutlet weak var slider: UISlider!
    
    //    @IBOutlet weak var titleView: UIView!
    
    //   @IBOutlet weak var titleLabel: UIView!
    
    
    var GoalDelegate: CreateGoalDelegate!
    
    let store = EKEventStore()
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GoalTextView.layer.cornerRadius = 15
        GoalTextView.clipsToBounds = true
        GoalTextView.layer.borderColor = UIColor.darkGray.cgColor
        GoalTextView.layer.borderWidth = 1
        
        NoteTextView.layer.cornerRadius = 15
        NoteTextView.clipsToBounds = true
        NoteTextView.layer.borderColor = UIColor.darkGray.cgColor
        NoteTextView.layer.borderWidth = 1
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(red: 0.74, green: 0.7, blue: 0.98, alpha: 1).cgColor, UIColor.init(red: 0.35, green: 0.78, blue: 1, alpha: 1).cgColor]
        
        gradient.startPoint = CGPoint(x: 0.20, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.80, y: 0.5)
        
        
        
        
    }
    
    
    
    
    @IBAction func backTapped(_ sender: Any) {
        GoalDelegate.didTapButtons()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if GoalTextView.text != ""{
            let db = Firestore.firestore()
            let reference = db.collection("Goals").document(Auth.auth().currentUser!.uid)
            reference.getDocument { (docSnapshot, error) -> Void in
                
                if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                    
                    GoalModel.GoalArray.append([
                        "GoalTitle": self.GoalTextView.text as Any,
                        "GoalNote": self.NoteTextView.text as Any,
                        "masteryNum": Int(self.slider.value)
                    ])
                    print(GoalModel.GoalArray)
                    AchievementsHelper.increaseGoalMade()
                    self.GoalDelegate.didTapButtons()
                    
                    reference.updateData(["GoalArray" : FieldValue.arrayUnion([[
                        "GoalTitle": self.GoalTextView.text as Any,
                        "GoalNote": self.NoteTextView.text as Any,
                        "masteryNum":Int(self.slider.value)
                    ]])
                    ])
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addToCalendarPressed(_ sender: Any) {
        
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = self.GoalTextView.text
                    event.notes = self.NoteTextView.text
                    event.startDate = Date()
                    event.endDate = Date()
                    
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                    
                    
                }
            }
        })
    }
}

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX + 20, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.maxX - 50, height: 7))
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.minimumTrackTintColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        self.maximumTrackTintColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        
    }
}

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
