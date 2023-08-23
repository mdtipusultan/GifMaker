import UIKit
import ImageIO
import MobileCoreServices
import Photos
import AVKit
import AVFoundation

class photoToGifEditVC: UIViewController {
    var selectedImages: [UIImage] = []
    
    @IBOutlet weak var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().backgroundColor = .darkGray//232323
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.lightGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Use the 'selectedImages' array here to edit the photos or perform other operations
        
        print("Selected images in photoToGifEditVC: \(selectedImages)")
        
        
        // Convert the selected images to a GIF and set it as the image of gifView
        if let gifData = createGIF(from: selectedImages) {
            gifView.loadGif(from: gifData)
        }
    }
    
        func createGIF(from images: [UIImage]) -> Data? {
            let gifProperties = [
                kCGImagePropertyGIFDictionary: [
                    kCGImagePropertyGIFLoopCount: 0 // 0 means loop indefinitely
                ]
            ] as CFDictionary
            
            // Create an empty data object for the GIF
            let imageData = NSMutableData()
            
            // Create the GIF destination
            guard let destination = CGImageDestinationCreateWithData(imageData, kUTTypeGIF, images.count, nil) else {
                return nil
            }
            
            // Add each frame to the GIF
            for image in images {
                if let cgImage = image.cgImage {
                    let frameProperties = [
                        kCGImagePropertyGIFDictionary: [
                            kCGImagePropertyGIFDelayTime: 0.2 // Set the delay time for each frame (adjust as needed)
                        ]
                    ] as CFDictionary
                    
                    CGImageDestinationAddImage(destination, cgImage, frameProperties)
                }
            }
            
            // Set the GIF properties and finalize the destination
            CGImageDestinationSetProperties(destination, gifProperties)
            CGImageDestinationFinalize(destination)
            
            return imageData as Data
        }
        
        
        @IBAction func cancleButton(_ sender: UIBarButtonItem) {
            dismiss(animated: true)
        }
        
        
        @IBAction func saveButton(_ sender: UIBarButtonItem) {
            guard let gifData = createGIF(from: selectedImages) else {
                print("Error creating GIF.")
                return
            }
            // Save the GIF data to UserDefaults
            let userDefaults = UserDefaults.standard
            var savedGifs = userDefaults.array(forKey: "savedGifs") as? [Data] ?? []
            savedGifs.append(gifData)
            userDefaults.set(savedGifs, forKey: "savedGifs")
            
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard status == .authorized else {
                    print("Permission to access photo library denied.")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .photo, data: gifData, options: nil)
                } completionHandler: { [weak self] success, error in
                    if success {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Success", message: "GIF saved to the photo library!", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self?.present(alertController, animated: true, completion: nil)
                        }
                    } else {
                        print("Error saving GIF to the photo library: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
}
    extension UIImageView {
        func loadGif(from data: Data) {
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                return
            }
            
            var images: [UIImage] = []
            let count = CGImageSourceGetCount(source)
            
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let image = UIImage(cgImage: cgImage)
                    images.append(image)
                }
            }
            
            self.animationImages = images
            self.animationDuration = TimeInterval(count) * 0.2 // Set the animation duration based on the number of frames and delay time
            self.startAnimating()
        }
    }
