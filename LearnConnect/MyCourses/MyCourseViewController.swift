//
//  MyCourseViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 22.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class MyCourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.title  // cell'e kurs başlığını atıyoruz

        return cell
    }
   
    
    @IBOutlet weak var myCoursesTableView: UITableView!
    
    
    
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCoursesTableView.dataSource = self
        myCoursesTableView.delegate = self
        fetchUserCourses()
    }
    
    func fetchUserCourses() {
        guard let user = Auth.auth().currentUser else {
            print("User is not logged in.")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(user.uid)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("No user document found.")
                return
            }
            
            if let enrolledCourses = document.data()?["enrolledCourses"] as? [String: [String: Any]] {
                self.courses = enrolledCourses.compactMap { (key, value) -> Course? in
                    guard let title = value["title"] as? String else { return nil }
                    return Course(title: title, description: nil, id: nil, videoURL: "")
                }
                DispatchQueue.main.async {self.myCoursesTableView.reloadData()}
            }
        }
    }
}


    

    

    

