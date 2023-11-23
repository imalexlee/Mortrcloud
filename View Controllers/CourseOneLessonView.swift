//
//  CourseOneLessonView.swift
//  mortrcloud
//
//  Created by Alex Lee on 3/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol CourseOneLessonViewProtocol {
    func quizChosen()
}

class CourseOneLessonView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var LessonsTableView: UITableView!
    
    @IBOutlet weak var headerImage: UIImageView!
    
    var delegate:CourseOneLessonViewProtocol?
    
    var HeaderView:UIView!
    var NewHeaderLayer:CAShapeLayer!
    
    private let Headerheight: CGFloat = 250
    private let Headercut: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "course1TableViewCell", bundle: nil)
        LessonsTableView.register(nib, forCellReuseIdentifier: "course1TableViewCell")
        
        let nib2 = UINib(nibName: "LessonHeaderCell", bundle: nil)
        LessonsTableView.register(nib2, forCellReuseIdentifier: "LessonHeaderCell")
        
        LessonsTableView.delegate = self
        LessonsTableView.dataSource = self
        self.UpdateView()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func UpdateView(){
        //LessonsTableView.backgroundColor = UIColor.white
        HeaderView = LessonsTableView.tableHeaderView
        LessonsTableView.tableHeaderView = nil
        LessonsTableView.addSubview(HeaderView)
        
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        HeaderView.layer.mask = NewHeaderLayer
        
        let newHeight = Headerheight - Headercut/2
        LessonsTableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        LessonsTableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        
       self.setupNewView()
    }
    
    func setupNewView(){
        let newHeight = Headerheight - Headercut / 2
        var getHeaderFrame = CGRect(x: 0, y: -newHeight, width: LessonsTableView.bounds.width, height: Headerheight)
        if LessonsTableView.contentOffset.y < newHeight {
            getHeaderFrame.origin.y = LessonsTableView.contentOffset.y
            getHeaderFrame.size.height = -LessonsTableView.contentOffset.y + Headercut/2
        }
        
        HeaderView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width + 10, y: getHeaderFrame.height ))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height - Headercut + 20))
        NewHeaderLayer.path = cutDirection.cgPath
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.LessonsTableView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setupNewView()
 
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        GeneralHelper().checkTime()
        LessonsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "course1TableViewCell") as! course1TableViewCell
       
    
         
        cell.course1LessonCellLabel.text = GeneralHelper.courseTitles[GeneralHelper.currentCourseIndex][indexPath.row]
        if indexPath.row == 0{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "LessonHeaderCell") as! LessonHeaderCell
            cell2.LessonHeaderTitle.text = GeneralHelper.courseLabel[GeneralHelper.currentCourseIndex]
            cell2.LessonHeaderSubtitle.text = GeneralHelper.headers[GeneralHelper.currentCourseIndex]
            return cell2
        }
        if indexPath.row > 0 {
            cell.course1LeftLabel.text = String(indexPath.row)
        }
        switch GeneralHelper.currentCourseIndex {
        
       
        case 0:
            headerImage.image = UIImage(named: "blue mountain")
            cell.course1LeftLabel.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.93, alpha: 1)
            if GeneralHelper.course0complete[indexPath.row] as! Int == 1 {
                cell.completeImage.tintColor = UIColor(red: 109/255, green: 187/255, blue: 136/255, alpha: 1.0)
                cell.completeImage.image = UIImage(systemName: "checkmark")
            } else{
                cell.completeImage.tintColor = UIColor.lightGray
                cell.completeImage.image = UIImage(systemName: "circle")
            }
        case 1:
            headerImage.image = UIImage(named: "watchtower")
            cell.course1LeftLabel.textColor = UIColor(red: 0.83, green: 0.31, blue: 0.32, alpha: 1)
            if GeneralHelper.course1complete[indexPath.row] as! Int == 1 {
                cell.completeImage.tintColor = UIColor(red: 109/255, green: 187/255, blue: 136/255, alpha: 1.0)
                cell.completeImage.image = UIImage(systemName: "checkmark")
            } else{
                cell.completeImage.tintColor = UIColor.lightGray
                cell.completeImage.image = UIImage(systemName: "circle")
            }
        case 2:
            headerImage.image = UIImage(named: "campfire")
            cell.course1LeftLabel.textColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1)
            if GeneralHelper.course2complete[indexPath.row] as! Int == 1 {
                cell.completeImage.tintColor = UIColor(red: 109/255, green: 187/255, blue: 136/255, alpha: 1.0)
                cell.completeImage.image = UIImage(systemName: "checkmark")
            } else{
                cell.completeImage.tintColor = UIColor.lightGray
                cell.completeImage.image = UIImage(systemName: "circle")
            }
        case 3:
            headerImage.image = UIImage(named: "dark forest")
            cell.course1LeftLabel.textColor = UIColor(red: 0.48, green: 0.35, blue: 0.45, alpha: 1)
            if GeneralHelper.course3complete[indexPath.row] as! Int == 1 {
                cell.completeImage.tintColor = UIColor(red: 109/255, green: 187/255, blue: 136/255, alpha: 1.0)
                cell.completeImage.image = UIImage(systemName: "checkmark")
            } else{
                cell.completeImage.tintColor = UIColor.lightGray
                cell.completeImage.image = UIImage(systemName: "circle")
            }
        default:
            print("unable to display status circles")
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleX": GeneralHelper.currentCourseIndex], merge: true)
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([ "courseTitleY": indexPath.row], merge: true)
        if indexPath.row % 2 == 0 && indexPath.row > 0{
            GeneralHelper.currentJsonName = "json\(GeneralHelper.currentCourseIndex).\(indexPath.row - 1)"
            GeneralHelper.currentArticleIndex = indexPath.row
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "quizView")
            AchievementsHelper.increaseQuizTaken(indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                let cell:course1TableViewCell = self.LessonsTableView.cellForRow(at: indexPath) as! course1TableViewCell
                cell.completeImage.tintColor = UIColor(red: 109/255, green: 187/255, blue: 136/255, alpha: 1.0)
                cell.completeImage.image = UIImage(systemName: "checkmark")
            }
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            
            delegate?.quizChosen()
            
            
        } else if( indexPath.row % 2 != 0 && indexPath.row > 0) {
            
            GeneralHelper.currentJsonName = "json\(GeneralHelper.currentCourseIndex).\(indexPath.row - 1)"
            GeneralHelper.currentArticleIndex = indexPath.row
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "articleView")
            AchievementsHelper.increaseArticleRead(indexPath.row)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                let cell:course1TableViewCell = self.LessonsTableView.cellForRow(at: indexPath) as! course1TableViewCell
                cell.completeImage.tintColor = UIColor(red: 109/255, green: 187/255, blue: 136/255, alpha: 1.0)
                cell.completeImage.image = UIImage(systemName: "checkmark")
            }
            
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
        
        GeneralHelper().setTotal()
        GeneralHelper().setArray(GeneralHelper.currentCourseIndex, GeneralHelper.currentArticleIndex)
        LessonsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
}
