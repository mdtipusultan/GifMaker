import UIKit
import AVFoundation
import ImageIO
import SwiftyGif


class videoToGifEditVC: UIViewController {

    var videoURL: URL?
    
    @IBOutlet weak var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        let gifOutputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.gif")
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            completion(nil)
            return
        }
        
        exportSession.outputFileType = .mov // Use .mov as the output file type
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
        do {
            let gif = try UIImage(gifUrl: gifURL)
            gifView.setGifImage(gif, loopCount: -1) // Set loopCount to -1 for infinite looping
        } catch {
            print("Error loading GIF: \(error)")
        }
    }

    
    @IBAction func cancleButttonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButttonTapped(_ sender: UIBarButtonItem) {
        // You can implement saving the GIF here
    }
    
}
