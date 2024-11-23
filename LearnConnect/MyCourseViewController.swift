//
//  MyCourseViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 22.11.2024.
//

import UIKit

final class MyCourseViewController: UIViewController {
    
    var course: Course?
    
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var courseDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show course info
        courseTitleLabel.text = course?.title
        courseDescriptionLabel.text = course?.description

    }
}
