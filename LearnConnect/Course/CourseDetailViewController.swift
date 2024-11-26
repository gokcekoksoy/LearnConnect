//
//  CourseDetailViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 25.11.2024.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth

class CourseDetailViewController: UIViewController {
    
    var course: Course?
    var player: AVPlayer?
    private var selectedCourse: Course?
   
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = course?.title
        descriptionLabel.text = course?.description
        setVideoPlayerAndThumbnail()
        

    }
    
    private func showAlert(message: String) {
           let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    
    private func setVideoPlayerAndThumbnail() {
        guard let videoURLString = course?.videoURL, let videoURL = URL(string: videoURLString), let courseID = course?.id else {
            print("Wrong URL.")
            return
        }
        player = AVPlayer(url: videoURL)
        imageView.image = getThumbnail(from: videoURL, at: 2.0)
        let progress = getVideoProgress(for: "\(courseID)")
        player?.seek(to: CMTime(seconds: Double(progress), preferredTimescale: 1))
        guard let player else { return }
        
        observeVideoProgress(for: player, courseID: "\(courseID)")
        
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        
    }
    
    func getThumbnail(from videoURL: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true // Ensure correct orientation

        let time = CMTime(seconds: time, preferredTimescale: 60)

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
                
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    @IBAction func enrollButtonTapped(_ sender: Any) {
        enrollInCourse()
    }
    
    private func enrollInCourse() {
        
        guard let user = Auth.auth().currentUser else {
                print("User is not logged in.")
                return
            }
        guard let course = course else {
                print("Course information not found.")
                return
            }
        
            let db = Firestore.firestore()
            let userRef = db.collection("Users").document(user.uid)
            
        userRef.setData([
                "name": user.displayName ?? "Unknown",
                "email": user.email ?? "Unknown",
                "enrolledCourses": [
                    "\(String(describing: course.id))": [
                        "title": course.title,
                        "description": course.description,
                        "videoURL": course.videoURL
                    ]
                ]
            ], merge: true) { error in
                if let error = error {
                    self.showAlert(message: "An error occured while enroling the course. Please try again.")
                } else {
                    self.showAlert(message: "Successfull enrolled!")
                }
            }
    }
    
   
    
    @IBAction func playButtonTepped(_ sender: Any) {
        playVideo()
    }
    
    func playVideo() {
        
        let playerViewController = AVPlayerViewController() //
        playerViewController.player = player //
        
        present(playerViewController, animated: true) {
            self.player?.play() //
        }
    }
    
    @objc func playerDidFinishPlaying(notification: Notification) {
        player?.seek(to: .zero)
        if let courseID = course?.id {
            saveVideoProgress(for: "\(courseID)", progress: .zero)
        }
    }
    
    func observeVideoProgress(for player: AVPlayer, courseID: String) {
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            let progress = CMTimeGetSeconds(time)  // Videonun şu anki süresi
            self?.saveVideoProgress(for: courseID, progress: Float(progress))  // Videonun ilerlemesini kaydet
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
