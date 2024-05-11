import UIKit
import AVFoundation
import FLAnimatedImage
import Photos
import Regift
import ImageIO
import MobileCoreServices

class videoToGifEditVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var videoURL: URL?
    var selectedGif: Gif?
    var selectedImages: [UIImage] = []
    
    let data: [(image: UIImage, title: String)] = [
        (UIImage(systemName: "speedometer")!, "SPEED"),
        (UIImage(systemName: "crop")!, "CANVAS"),
        (UIImage(systemName: "aqi.medium")!, "BG"),
        (UIImage(systemName: "character.textbox")!, "BORDER"),
        (UIImage(systemName: "slider.horizontal.3")!, "EDIT"),
        (UIImage(systemName: "figure.gymnastics")!, "STICKER"),
        (UIImage(systemName: "textformat")!, "TEXT"),
        (UIImage(systemName: "cube.box")!, "MANAGE"),
        (UIImage(systemName: "camera.filters")!, "FILTER"),
        (UIImage(systemName: "slider.horizontal.2.gobackward")!, "ADJUST")
    ]
    
    @IBOutlet weak var gifView: FLAnimatedImageView!
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.dataSource = self
        collectionview.delegate = self
        
        setUp()
    }
    func setUp(){
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
        
        // Convert the selected images to a GIF and set it as the image of gifView
        if let gifData = createGIF(from: selectedImages) {
            let animatedGif = FLAnimatedImage(animatedGIFData: gifData)
            gifView.animatedImage = animatedGif
        }
        
        if let layout = collectionview.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
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
    //MARK: IMAGES TO GIF
    func createGIF(from images: [UIImage]) -> Data? {
        // Create an empty data object for the GIF
        let imageData = NSMutableData()
        
        // Create the GIF destination
        guard let destination = CGImageDestinationCreateWithData(imageData, kUTTypeGIF, images.count, nil) else {
            return nil
        }
        
        // Set the GIF properties
        let gifProperties = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFLoopCount: 0 // 0 means loop indefinitely
            ]
        ] as CFDictionary
        CGImageDestinationSetProperties(destination, gifProperties)
        
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
        
        // Finalize the destination
        if !CGImageDestinationFinalize(destination) {
            print("Failed to finalize GIF destination")
            return nil
        }
        
        return imageData as Data
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
    //MARK: SAVE VIDEO GIF ANF GIF TO DEVICE
    func saveGifToPhotoLibrary(gifURL: URL) {
        URLSession.shared.dataTask(with: gifURL) { data, response, error in
            if let data = data {
                // Create a temporary file URL in the app's temporary directory
                let temporaryDirectory = FileManager.default.temporaryDirectory
                let temporaryGifURL = temporaryDirectory.appendingPathComponent("temporaryGif.gif")
                
                do {
                    // Write the downloaded GIF data to the temporary location
                    try data.write(to: temporaryGifURL)
                    // Save the GIF data to UserDefaults
                    let userDefaults = UserDefaults.standard
                    var savedGifs = userDefaults.array(forKey: "savedGifs") as? [Data] ?? []
                    savedGifs.append(data)
                    userDefaults.set(savedGifs, forKey: "savedGifs")
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
    //MARK: SAVE IMAGES GIF TO DEVICE
    func saveGifToPhotoLibraryFromData(gifData: Data) {
        // Create a temporary file URL in the app's temporary directory
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let temporaryGifURL = temporaryDirectory.appendingPathComponent("temporaryGif.gif")
        
        do {
            // Write the GIF data to the temporary location
            try gifData.write(to: temporaryGifURL)
            // Save the GIF data to UserDefaults
            let userDefaults = UserDefaults.standard
            var savedGifs = userDefaults.array(forKey: "savedGifs") as? [Data] ?? []
            savedGifs.append(gifData)
            userDefaults.set(savedGifs, forKey: "savedGifs")
            
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
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        // Handle cancel action (e.g., dismiss the view controller)
        dismiss(animated: true, completion: nil)
    }
    //MARK: SAVE-BUTTON TAPPED
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
        } else if !selectedImages.isEmpty {
            
            // Convert selected images to GIF and save it to the photo library
            if let gifData = createGIF(from: selectedImages) {
                saveGifToPhotoLibraryFromData(gifData: gifData)
                print(gifData)
            }
        }
    }
    
    //MARK: COLLECTION-VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! gifEditCollectionViewCell
        
        let item = data[indexPath.row]
        
        cell.imageTittle.text = item.title
        
        cell.imageicon.image = item.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showToast(message: "Feature will be available soon.", font: .systemFont(ofSize: 14.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 20) / 5 // Assuming you want five cells per row and a 10-point spacing between cells
        let cellHeight = cellWidth // You can adjust this as needed
        
        print("Cell width: \(cellWidth), Cell height: \(cellHeight)")
        
        return CGSize(width: cellWidth, height: cellHeight)
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
        
        // Print the count of loaded images
        print("Loaded images count: \(images.count)")
        
        self.animationImages = images
        self.animationDuration = TimeInterval(count) * 0.2
        self.startAnimating()
    }
}
