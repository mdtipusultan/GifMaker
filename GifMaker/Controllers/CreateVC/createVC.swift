import UIKit
import PhotosUI
import MobileCoreServices

// Define the protocol
protocol CreateVCDelegate: AnyObject {
    func didSelectImages(_ images: [UIImage])
}

class createVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionview: UICollectionView!
    var selectedVideoURL: URL?

    
    let data: [(image: UIImage, title: String, description: String)] = [
        (UIImage(systemName: "video")!, "Video to GIF", "You can convert your videos to gif"),
        (UIImage(systemName: "photo")!, "Photo to GIF", "You can create gifs by selecting your multiple photos"),
        (UIImage(systemName: "star")!, "GIF Editor", "You can edit or create your GIFs"),
        (UIImage(systemName: "play.circle")!, "GIF Moments", "You can create GIF from your moments"),
        (UIImage(systemName: "rectangle.compress.vertical")!, "Compress GIF", "You can compress your GIF"),
        (UIImage(systemName: "infinity.circle")!, "Loop GIF", "You can convert your capture video into Loop GIFs")
    ]
    
    weak var delegate: CreateVCDelegate?
    var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionview.collectionViewLayout = flowLayout
    }
    @IBAction func purchaseBUttonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Purchase", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "purchaseVC")
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    //MARK: COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! createCollectionViewCell
        let item = data[indexPath.item]
        cell.logoImage.image = item.image
        cell.logoName.text = item.title
        cell.logoDetails.text = item.description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            // "Video to GIF" selected
            openVideoPicker()
        case 1:
            // "Photo to GIF" selected
            openPhotoLibrary()
            
        case 2:
            // "GIF Editor" selected
            print("GIF Editor selected")
        case 3:
            // "GIF Moments" selected
            print("GIF Moments selected")
        case 4:
            // "Compress GIF" selected
            print("Compress GIF selected")
        case 5:
            // "Loop GIF" selected
            print("Loop GIF selected")
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        let screenHeight = UIScreen.main.bounds.height
        
        // Define the reference screen height and corresponding height value
        let referenceScreenHeight: CGFloat = 926
        let referenceHeight: CGFloat = 215
        
        // Calculate the proportional height based on the current screen height
        let height = (screenHeight / referenceScreenHeight) * referenceHeight
        return CGSize(width: width, height: height)
    }
    
    //MARK: VIDEO-PICKER
    func openVideoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [UTType.movie.identifier] // Use UTTypeMovie instead of kUTTypeMovie
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    // MARK: - UIImagePickerControllerDelegate Methods
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          
          if let videoURL = info[.mediaURL] as? URL {
              // Call a method to send the video URL to a different view controller
              sendVideoToDifferentVC(videoURL)
          }
      }
    // MARK: - Send Video to Different VC
     func sendVideoToDifferentVC(_ videoURL: URL) {
         // Instantiate the different view controller
         //let destinationVC = videoToGifEditVC()
         
         
         
         // Present the different view controller
         //navigationController?.pushViewController(destinationVC, animated: true)
         
         
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let destinationVC = storyboard.instantiateViewController(withIdentifier: "videoToGifEditVC") as? videoToGifEditVC {
             // Pass the video URL to the different view controller
             destinationVC.videoURL = videoURL
             let navigationController = UINavigationController(rootViewController: destinationVC)
             navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
             self.present(navigationController, animated: true, completion: nil)
         }
     }

    func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // Set to 0 for unlimited selection, or a specific number for a limit
        configuration.filter = .images // This line filters to show only images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
/*
    //i dont know but its not reaching that point
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoToGifEditVC" {
            if let destinationVC = segue.destination as? photoToGifEditVC {
                
                
                destinationVC.selectedImages = selectedImages // Pass the selected images to the photoToGifEditVC
            }
        }
    }
    */
}

extension createVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if results.isEmpty {
            // User canceled the selection
            print("User canceled the selection.")
        } else {
            
            // User tapped on the "Add" button and selected one or more items
            var selectedImages: [UIImage] = []
            
            let group = DispatchGroup()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            selectedImages.append(image)
                        }
                        group.leave()
                    }
                }
            }
            
            // Notify when all images have been loaded
            group.notify(queue: .main) { [weak self] in
                // Handle the selected images
                print(selectedImages)
                self?.delegate?.didSelectImages(selectedImages)
                //self?.performSegue(withIdentifier: "showPhotoToGifEditVC", sender: self)
                self?.showPhotoToGifEditVC(with: selectedImages)
            }
        }
    }
    
    func pickerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
        print("User canceled the selection.")
    }
    func showPhotoToGifEditVC(with images: [UIImage]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "photoToGifEditVC") as? photoToGifEditVC {
            destinationVC.selectedImages = images
            let navigationController = UINavigationController(rootViewController: destinationVC)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
