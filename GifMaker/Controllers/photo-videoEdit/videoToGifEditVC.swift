import UIKit
import AVFoundation
import Photos

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
        let asset = AVURLAsset(url: videoURL)
        let gifOutputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.mov")
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            completion(nil)
            return
        }
        
        exportSession.outputFileType = .mov
        exportSession.outputURL = gifOutputURL
        
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                DispatchQueue.main.async {
                    completion(gifOutputURL)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
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

               PHPhotoLibrary.shared().performChanges({
                   let creationRequest = PHAssetCreationRequest.forAsset()
                   creationRequest.addResource(with: .photo, data: gifData, options: nil)
               }) { success, error in
                   DispatchQueue.main.async {
                       if success {
                           // Show success alert
                       } else if let error = error {
                           // Print the detailed error description
                           print("Error saving GIF: \(error)")
                           
                           // Show an alert indicating error
                           let alert = UIAlertController(title: "Error", message: "An error occurred while saving the GIF.", preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           self.present(alert, animated: true, completion: nil)
                       }
                   }
               }

           }  catch {
               print("Error saving GIF: \(error)")
               
               // Show an alert indicating error
               let alert = UIAlertController(title: "Error", message: "An error occurred while saving the GIF.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
           }
       }
}
