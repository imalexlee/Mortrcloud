//
//  ArticleViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/17/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ArticleViewController: UIViewController, ArticleProtocol {
    
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        if GeneralHelper.currentArticleIndex < 5 {
            GeneralHelper.currentJsonName = "json\(GeneralHelper.currentCourseIndex).\(GeneralHelper.currentArticleIndex + 1)"
            GeneralHelper.currentArticleIndex += 1
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleX": GeneralHelper.currentCourseIndex], merge: true)
            db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleY": GeneralHelper.currentArticleIndex], merge: true)
        }
        if GeneralHelper.currentArticleIndex == 5 {
            DispatchQueue.main.async() { // Change `2.0` to the desired number of seconds.
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CourseOneLessonView.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    
    
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var ArticleTitle: UILabel!
    
    @IBOutlet weak var ArticleText: UILabel!
    
    
    var model = ArticleModel()
    var article = Article()
    
    var quizChose:CourseOneLessonView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.getArticle(GeneralHelper.currentJsonName)
        
        switch GeneralHelper.currentCourseIndex {
        case 0:
            articleImage.backgroundColor = UIColor(red: 0.43, green: 0.43, blue: 0.93, alpha: 1)
        case 1:
            articleImage.backgroundColor = UIColor(red: 0.83, green: 0.31, blue: 0.32, alpha: 1)
        case 2:
            articleImage.backgroundColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1)
        case 3:
            articleImage.backgroundColor = UIColor(red: 0.48, green: 0.35, blue: 0.45, alpha: 1)
        default:
            print("unable to display status circles")
        }
        
        GeneralHelper.x = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GeneralHelper().setTotal()
    }
    
    func displayArticle(){
        
        ArticleTitle.text = article.articleTitle
        ArticleText.text = article.articleText
        
    }
    
    
    func articleRetrieved(_ article: Article) {
        self.article = article
        displayArticle()
        
    }
    
    
    @IBAction func BackButtonTapped(_ sender: Any) {
        
        if GeneralHelper.currentArticleIndex > 0 {
            performSegue(withIdentifier: "articleToQuiz", sender: nil)
            GeneralHelper.currentJsonName = "json\(GeneralHelper.currentCourseIndex).\(GeneralHelper.currentArticleIndex - 1)"
            GeneralHelper.currentArticleIndex -= 1
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["courseTitleX": GeneralHelper.currentCourseIndex], merge: true)
            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["courseTitleY": GeneralHelper.currentArticleIndex], merge: true)
            GeneralHelper().setTotal()
            GeneralHelper().setArray(GeneralHelper.currentCourseIndex, GeneralHelper.currentArticleIndex)
        }
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
        if GeneralHelper.currentArticleIndex < 5 {
            performSegue(withIdentifier: "articleToQuiz", sender: nil)
            GeneralHelper.currentJsonName = "json\(GeneralHelper.currentCourseIndex).\(GeneralHelper.currentArticleIndex + 1)"
            GeneralHelper.currentArticleIndex += 1
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleX": GeneralHelper.currentCourseIndex], merge: true)
            db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleY": GeneralHelper.currentArticleIndex], merge: true)
            GeneralHelper().setTotal()
            GeneralHelper().setArray(GeneralHelper.currentCourseIndex, GeneralHelper.currentArticleIndex)
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}
