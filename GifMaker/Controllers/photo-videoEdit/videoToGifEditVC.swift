import UIKit
import AVFoundation
import FLAnimatedImage
import Photos
import Regift

class videoToGifEditVC: UIViewController {
    
    var videoURL: URL?
    
    @IBOutlet weak var gifView: FLAnimatedImageView! // Make sure to connect this IBOutlet in your storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the navigation bar color to your desired color
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear // Change this to your desired color
        
    }
    func convertVideoToGIF(videoURL: URL, completion: @escaping (URL?) -> Void) {
        let regift = Regift(sourceFileURL: videoURL, frameCount: 10, delayTime: 0.2, loopCount: 0)
        if let gifURL = regift.createGif() {
            completion(gifURL)
        } else {
            completion(nil)
        }
    }
    
    func displayGIF(from gifURL: URL) {
        // Display the GIF using the FLAnimatedImage library
        let gifData = try? Data(contentsOf: gifURL)
        if let gifData = gifData {
            let gif = FLAnimatedImage(animatedGIFData: gifData)
            gifView.animatedImage = gif
        }
    }
    
    func saveGifToPhotoLibrary(gifURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: gifURL)
            if let placeholder = request?.placeholderForCreatedAsset,
               let createdAsset = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil).firstObject {
                // Perform additional tasks with createdAsset if needed
                print("GIF saved to photo library with local identifier: \(createdAsset.localIdentifier)")
            }
        }) { success, error in
            if success {
                print("GIF saved to photo library")
            } else if let error = error {
                print("Error saving GIF: \(error)")
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        // Handle cancel action (e.g., dismiss the view controller)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let gifURL = videoURL {
            convertVideoToGIF(videoURL: gifURL) { convertedGifURL in
                if let gifURL = convertedGifURL {
                    self.saveGifToPhotoLibrary(gifURL: gifURL)
                }
            }
        }
    }
}
