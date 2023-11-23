//
//  EditGoalViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 6/12/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import EventKit
import EventKitUI

class EditGoalViewController: UIViewController, UITextViewDelegate,EKEventViewDelegate,UINavigationControllerDelegate, EKEventEditViewDelegate {
    
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var GoalTitle: UITextView!
    
    @IBOutlet weak var GoalNote: UITextView!
    
    @IBOutlet weak var slider: UISlider!
    
    //@IBOutlet weak var titleView: UIView!
   // @IBOutlet weak var GoalNoteHeight: NSLayoutConstraint!
    
    var receivedTitle = ""
    var receivedNote = ""
    var sliderPos = 0
    var cellIndex = 0
    
    let store = EKEventStore()
    let eventStore = EKEventStore()
    
    var textHeightConstraint: NSLayoutConstraint!
    
    var wasLaidOut:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GoalTitle.layer.cornerRadius = 15
        GoalTitle.clipsToBounds = true
        GoalTitle.layer.borderColor = UIColor.darkGray.cgColor
        GoalTitle.layer.borderWidth = 1
        
        GoalNote.layer.cornerRadius = 15
        GoalNote.clipsToBounds = true
        GoalNote.layer.borderColor = UIColor.darkGray.cgColor
        GoalNote.layer.borderWidth = 1
        
//        slider.minimumValueImage = "👎".image()
//        slider.maximumValueImage = "👍".image()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(red: 0.74, green: 0.7, blue: 0.98, alpha: 1).cgColor, UIColor.init(red: 0.35, green: 0.78, blue: 1, alpha: 1).cgColor]
        
        gradient.startPoint = CGPoint(x: 0.20, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.80, y: 0.5)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        wasLaidOut = false
    }
    
    @IBAction func DoneTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        let reference = db.collection("Goals").document(Auth.auth().currentUser!.uid)
        (GoalModel.GoalArray[cellIndex])["GoalTitle"] = self.GoalTitle.text
        (GoalModel.GoalArray[cellIndex])["GoalNote"] = self.GoalNote.text
        (GoalModel.GoalArray[cellIndex])["masteryNum"] = Int(self.slider.value)
        reference.getDocument { (docSnapshot, error) -> Void in
            
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                
                
                reference.setData([
                    "GoalArray": GoalModel.GoalArray
                ])
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCalendarPressed(_ sender: Any) {
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = self.GoalTitle.text
                    event.notes = self.GoalNote.text
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
    
    
    
    override func viewDidLayoutSubviews() {
        if !wasLaidOut {
            self.GoalTitle.text = self.receivedTitle
            self.GoalNote.text = self.receivedNote
            self.slider.setValue(Float(sliderPos), animated: false)
            self.wasLaidOut = true
        }
    }
}
