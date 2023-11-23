//
//  QuizViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/14/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class QuizViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol{
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var questionTableView: UITableView!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var quizStackView: UIStackView!
    
    @IBOutlet var backgroundView: UIView!
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog:ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize result dialog
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        questionTableView.delegate = self
        questionTableView.dataSource = self
        model.delegate = self
        model.getQuestions(GeneralHelper.currentJsonName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch GeneralHelper.currentCourseIndex{
        case 0:
            backgroundView.backgroundColor = UIColor(red: 0.43, green: 0.43, blue: 0.93, alpha: 1)
        case 1:
            backgroundView.backgroundColor = UIColor(red: 0.83, green: 0.31, blue: 0.32, alpha: 1)
        case 2:
            backgroundView.backgroundColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1)
        case 3:
            backgroundView.backgroundColor = UIColor(red: 0.48, green: 0.35, blue: 0.45, alpha: 1)
            
        default:
            print("unable to set quiz background color")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GeneralHelper().setTotal()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if GeneralHelper.x == 0 {
            for controller in (self.navigationController?.viewControllers ?? [UIViewController()]) as Array {
                
                if controller.isKind(of: CourseOneLessonView.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    func slideInQuestion(){
        
        stackViewTrailingConstraint.constant = -1000
        stackViewLeadingConstraint.constant = 1000
        //logoLeading.constant = 1000
        //logoTrailing.constant = -1000
        //logo.alpha = 0
        quizStackView.alpha = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewTrailingConstraint.constant = 0
            self.stackViewLeadingConstraint.constant = 0
            //self.logoTrailing.constant = 0
           // self.logoLeading.constant = 0
            self.quizStackView.alpha = 1
            //self.logo.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func slideOutQuestion(){
        
        stackViewTrailingConstraint.constant = 0
        stackViewLeadingConstraint.constant = 0
        //logoLeading.constant = 0
        //logoTrailing.constant = 0
        quizStackView.alpha = 1
        //logo.alpha = 1
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewTrailingConstraint.constant = 1000
            self.stackViewLeadingConstraint.constant = -1000
           // self.logoTrailing.constant = 1000
          //  self.logoLeading.constant = -1000
            self.quizStackView.alpha = 0
            //self.logo.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func displayQuestion(){
        //check if there are questions and currentQuestionIndex isn't out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        //display question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        //reload answers
        questionTableView.reloadData()
        
        //animate the question
        slideInQuestion()
        
    }
    
    //MARK: - QuizProtocol methods
    func questionsRetrieved(_ questions: [Question]) {
        print("Questions retrieved from model")
        
        //get reference to ques
        self.questions = questions
        
        //check if we should restore state before showing first question
        //        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        //
        //        if savedIndex != nil && savedIndex! < self.questions.count{
        //            //set current question to saved index
        //            currentQuestionIndex = savedIndex!
        //
        //            //retrieve num correct from storage
        //            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
        //
        //            if savedNumCorrect != nil {
        //                numCorrect = savedNumCorrect!
        //            }
        //        }
        
        //diplay 1st question
        displayQuestion()
        
        //reload tableview
        questionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 else {
            return 0
        }
        let currentQuestion = questions[currentQuestionIndex]
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        //cutomize it
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count{
                //set the answer text
                label!.text = question.answers![indexPath.row]
            }
            
        }
        
        //return it
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check if the right answer was chosen
        let question = questions[currentQuestionIndex]
        var titleText = ""
        if question.correctAnswerIndex! == indexPath.row {
            // user got it right :)
            titleText = "Correct!"
            numCorrect += 1
        }
        else {
            //user got it wrong :(
            titleText = "Incorrect"
        }
        
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        //show the popup
        if resultDialog != nil {
            
            //customize dialog text
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: - resultView ControllerProtocol Methods
    func dialogDismissed() {
        //increment current question
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            //user answered last question
            //show a summary dialog
            if resultDialog != nil {
                
                //customize dialog text
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) correct out of \(questions.count)"
                resultDialog!.buttonText = "Restart"
                
                DispatchQueue.main.async {
                    self.present(self.resultDialog!, animated: true, completion: nil)
                }
                
                //StateManager.clearState()
                
            }
            
        }
        else if currentQuestionIndex > questions.count {
            // Restart
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        }
        
        else if currentQuestionIndex < questions.count{
            
            //more questions to show
            //display next question
            displayQuestion()
            
            //slide in next question
            slideInQuestion()
            
            //save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        
        
    }
    
    func nextArticleCalled() {
        dismiss(animated: true, completion: nil)
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleX": GeneralHelper.currentCourseIndex], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleY": GeneralHelper.currentArticleIndex], merge: true)
        GeneralHelper().setTotal()
        GeneralHelper().setArray(GeneralHelper.currentCourseIndex, GeneralHelper.currentArticleIndex)
        GeneralHelper.x = 1
        
    }
    
    //    func LastArticleCalled() {
    //        dismiss(animated: true, completion: nil)
    //        let db = Firestore.firestore()
    //        db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleX": GeneralHelper.currentCourseIndex], merge: true)
    //        db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleY": GeneralHelper.currentArticleIndex], merge: true)
    //        GeneralHelper().setTotal()
    //        GeneralHelper().setArray(GeneralHelper.currentCourseIndex, GeneralHelper.currentArticleIndex)
    //        GeneralHelper.x = 1
    //    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func exitTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
