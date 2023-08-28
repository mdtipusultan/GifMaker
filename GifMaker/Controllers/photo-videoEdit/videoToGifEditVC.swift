import UIKit
import AVFoundation
import FLAnimatedImage
import Photos
import Regift

class videoToGifEditVC: UIViewController {
    
    var videoURL: URL?
    var selectedGif: Gif?
    
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
        
        selectedGifShowing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the navigation bar color to your desired color
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear // Change this to your desired color
        
    }
    func selectedGifShowing(){
        if let gif = selectedGif,
           let url = URL(string: gif.images.original.url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.gifView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                    }
                }
            }.resume()
        }
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
        URLSession.shared.dataTask(with: gifURL) { data, response, error in
            if let data = data {
                // Create a temporary file URL in the app's temporary directory
                let temporaryDirectory = FileManager.default.temporaryDirectory
                let temporaryGifURL = temporaryDirectory.appendingPathComponent("temporaryGif.gif")
                
                do {
                    // Write the downloaded GIF data to the temporary location
                    try data.write(to: temporaryGifURL)
                    
                    // Save the GIF from the temporary location to the photo library
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: temporaryGifURL)
                    }) { success, error in
                        if success {
                            print("GIF saved to photo library")
                        } else if let error = error {
                            print("Error saving GIF: \(error)")
                        }
                        
                        // Delete the temporary file after attempting to save
                        try? FileManager.default.removeItem(at: temporaryGifURL)
                    }
                } catch {
                    print("Error writing GIF data to temporary location: \(error)")
                }
            } else if let error = error {
                print("Error downloading GIF data: \(error)")
            }
        }.resume()
    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        // Handle cancel action (e.g., dismiss the view controller)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let gif = selectedGif {
            // Save the selected GIF to the photo library
            if let url = URL(string: gif.images.original.url) {
                saveGifToPhotoLibrary(gifURL: url)
            }
        } else if let gifURL = videoURL {
            // Convert the video to GIF and save it to the photo library
            convertVideoToGIF(videoURL: gifURL) { convertedGifURL in
                if let gifURL = convertedGifURL {
                    self.saveGifToPhotoLibrary(gifURL: gifURL)
                }
            }
        }
    }
}
