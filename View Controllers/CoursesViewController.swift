//
//  CoursesViewController.swift
//  mortrcloud
//
//  Created by Alex Lee on 2/5/21.
//

import UIKit


class CoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var CoursesTableVIew: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CoursesTableViewCell", bundle: nil)
        CoursesTableVIew.register(nib, forCellReuseIdentifier: "CoursesTableViewCell")
        CoursesTableVIew.delegate = self
        CoursesTableVIew.dataSource = self
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesTableViewCell") as! CoursesTableViewCell
        //cell.courseImage.image = UIImage(named: "Screen Shot 2021-02-23 at 3.51.11 PM")
        cell.courseTitle.text = GeneralHelper.courseLabel[indexPath.row]
        cell.courseSubtitle.text = GeneralHelper.courseSubtitle[indexPath.row]
        //cell.courseSubtitle.text = GeneralHelper.courseSubtitle[indexPath.row]
//        cell.courseImage.image = UIImage(named: "Rectangle \(indexPath.row + 1)")
        switch indexPath.row{
        case 0:
            cell.courseSubtitle.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.93, alpha: 1)
            cell.courseIconImage.image = UIImage(named: "conversation")
        case 1:
            cell.courseSubtitle.textColor = UIColor(red: 0.83, green: 0.31, blue: 0.32, alpha: 1)
            cell.courseIconImage.image = UIImage(named: "feelings")
        case 2:
            cell.courseSubtitle.textColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1)
            cell.courseIconImage.image = UIImage(named: "loudspeaker")
        case 3:
            cell.courseSubtitle.textColor = UIColor(red: 0.48, green: 0.35, blue: 0.45, alpha: 1)
            cell.courseIconImage.image = UIImage(named: "question")
        default:
            print("unable to display status circles")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GeneralHelper.currentCourseIndex = indexPath.row
        performSegue(withIdentifier: "ShowLessons1", sender: nil)
        CoursesTableVIew.deselectRow(at: indexPath, animated: true)
    }
    
}
