//
//  CourseDetailViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 25.11.2024.
//

import UIKit

class CourseDetailViewController: UIViewController {
    
    var course: Course?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = course?.title
        descriptionLabel.text = course?.description
        
    }
}
