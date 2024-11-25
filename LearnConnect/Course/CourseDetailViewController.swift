//
//  CourseDetailViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 25.11.2024.
//

import UIKit
import AVKit
import AVFoundation

class CourseDetailViewController: UIViewController {
    
    var course: Course?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = course?.title
        descriptionLabel.text = course?.description
        
    }
    
    @IBAction func playButtonTepped(_ sender: Any) {
        playVideo()
    }
    
    func playVideo() {
        guard let videoURLString = course?.videoURL, let videoURL = URL(string: videoURLString) else {
            print("Wrong URL.")
            return
        }

        let player = AVPlayer(url: videoURL)
        let progress = getVideoProgress(for: String(course?.id ?? 0))
        player.seek(to: CMTime(seconds: Double(progress), preferredTimescale: 1))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    func saveVideoProgress(for courseID: String, progress: Float) {
        let defaults = UserDefaults.standard
        defaults.set(progress, forKey: "videoProgress_\(courseID)")
    }
    
    func getVideoProgress(for courseID: String) -> Float {
        let defaults = UserDefaults.standard
        return defaults.float(forKey: "videoProgress_\(courseID)")
    }
}
