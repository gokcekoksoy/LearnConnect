//
//  CourseViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 22.11.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class CourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        cell.textLabel?.text = courses[indexPath.row].title
        return cell
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCourses()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchCourses() {
        let db = Firestore.firestore()
        
        db.collection("Courses").getDocuments { (snapshot, error) in
            guard error == nil else {
                print("Could not fetch courses: \(error?.localizedDescription ?? "")")
                return
            }
            
            self.courses = snapshot?.documents.compactMap { doc -> Course? in
                let data = doc.data()
                return Course(title: data["title"] as? String,
                              description: data["description"] as? String,
                              id: data["id"] as? Int,
                              videoURL: data["videoURL"] as! String)
            } ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func enrollButtonTapped(_ sender: Any) {
        enrollInCourse()
    }
    
    private func enrollInCourse() {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCourse = courses[indexPath.row]
        performSegue(withIdentifier: "toCourseDetailVC", sender: selectedCourse)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetailVC" {
            if let destinationVC = segue.destination as? CourseDetailViewController,
               let selectedCourse = sender as? Course {
                destinationVC.course = selectedCourse
            }
        }
    } 
}
