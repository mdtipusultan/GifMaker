import UIKit
import AVFoundation

class videoToGifEditVC: UIViewController {
    
    var videoURL: URL?
    var player: AVPlayer?
    
    @IBOutlet weak var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
            // Ensure the gifView is not nil before accessing its properties
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = gifView.bounds
            gifView.layer.addSublayer(playerLayer)
            if let videoURL = videoURL {
                convertVideoToGIF(videoURL: videoURL) { gifURL in
                    if let gifURL = gifURL {
                        DispatchQueue.main.async {
                            self.displayGIF(from: gifURL)
                        }
                    }
                }
            }
        
    }
    
    func convertVideoToGIF(videoURL: URL, completion: @escaping (URL?) -> Void) {
        // Convert the video to a GIF if needed (e.g., using AVAssetExportSession)
        // Set the completion handler to return the URL of the generated GIF
        // completion(gifOutputURL)
        // For this example, let's assume you've prepared the GIF URL already
        completion(videoURL)
    }
    
    func displayGIF(from gifURL: URL) {
        // Create an AVPlayer with the video URL (GIF)
        player = AVPlayer(url: gifURL)
        player?.actionAtItemEnd = .none
        
        // Create an AVPlayerLayer to display the video in the UIImageView
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = gifView.bounds
        gifView.layer.addSublayer(playerLayer)
        
        // Loop the video
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        // Start playing the video
        player?.play()
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        player?.pause()
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Make sure a GIF has been loaded
        guard let playerItem = player?.currentItem,
              let asset = playerItem.asset as? AVURLAsset else {
            return
        }
        
        // Prepare the GIF data
        do {
            let gifData = try Data(contentsOf: asset.url)
            
            // Choose the save location (e.g., documents directory)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let saveURL = documentsDirectory.appendingPathComponent("savedGIF.gif")
            
            // Save the GIF data to the chosen location
            try gifData.write(to: saveURL)
            
            // Show an alert indicating successful saving
            let alert = UIAlertController(title: "GIF Saved", message: "The GIF has been saved to your documents directory.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } catch {
            print("Error saving GIF: \(error)")
            
            // Show an alert indicating error
            let alert = UIAlertController(title: "Error", message: "An error occurred while saving the GIF.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }


}
