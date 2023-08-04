import UIKit

class PurchaseVC: UIViewController {
    
    var currentIndex: Int = 0
    
    //@IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gifMakerProLable: UIView!
    let images = [UIImage(named: "emoticon"), UIImage(named: "devil"), UIImage(named: "cool"), UIImage(named: "angry")]
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifMakerProLable.layer.cornerRadius = 10
        
        // Set up the scroll view
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        // Calculate the total content width based on the number of images
        let totalContentWidth = CGFloat(images.count + 2) * view.bounds.width
        
        // Set the scroll view content size
        scrollView.contentSize = CGSize(width: totalContentWidth, height: scrollView.bounds.height)
        
        // Add image views for each image
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: CGFloat(index + 1) * view.bounds.width, y: 0, width: view.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(imageView)
        }
        
        // Duplicate the first and last images for circular scrolling
        let firstImageView = UIImageView(image: images.last as? UIImage)
        firstImageView.contentMode = .scaleAspectFit
        firstImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(firstImageView)
        
        let lastImageView = UIImageView(image: images.first as? UIImage)
        lastImageView.contentMode = .scaleAspectFit
        lastImageView.frame = CGRect(x: CGFloat(images.count + 1) * view.bounds.width, y: 0, width: view.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(lastImageView)
        
        // Set the initial content offset to show the second image
        scrollView.contentOffset = CGPoint(x: view.bounds.width, y: 0)
        
        // Start the automatic scrolling with a 3-second interval
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }
    @objc func scrollToNextImage() {
        let newX = scrollView.contentOffset.x + scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the navigation bar color to your desired color
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear // Change this to your desired color
        //startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset the navigation bar color to the original color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) // Change this to your original color
    }
    
    @IBAction func CloseButtonTapped(_ sender: UIBarButtonItem) {
        //self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        //_ = navigationController?.popToRootViewController(animated: true)
    }
}
extension PurchaseVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if the scroll view reaches the end, and reset the content offset to create the wheel effect
        if scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.width {
            scrollView.contentOffset.x = view.bounds.width
        } else if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset.x = scrollView.contentSize.width - 2 * scrollView.bounds.width
        }
    }
}
