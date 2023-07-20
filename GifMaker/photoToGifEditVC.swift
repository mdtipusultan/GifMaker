import UIKit

class photoToGifEditVC: UIViewController {
    var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().backgroundColor = .darkGray//232323
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.lightGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Use the 'selectedImages' array here to edit the photos or perform other operations
        
        print("Selected images in photoToGifEditVC: \(selectedImages)")
    }
}
