import UIKit

class PurchaseVC: UIViewController {

    var currentIndex: Int = 0

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var gifMakerProLable: UIView!
    
    @IBOutlet weak var subscriptionView: UIView!
    
    @IBOutlet weak var yearView: UIView!
    
    @IBOutlet weak var monthView: UIView!
    
    @IBOutlet weak var freeView: UIView!
    
    @IBOutlet weak var tryAndSubscribeLable: UIView!
    
    
    let images = [UIImage(named: "emoticon"), UIImage(named: "devil"), UIImage(named: "cool"), UIImage(named: "angry")]

    // Array of titles corresponding to each image
    let imageTitles = ["Emoticon", "Devil", "Cool", "Angry"]
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        gifMakerProLable.layer.cornerRadius = 10

        // Set up the scroll view
        scrollView.isPagingEnabled = false
        scrollView.delegate = self

        // Configure the scrollView content size to fit the circular arrangement of images and titles
        let imageWidth: CGFloat = scrollView.frame.width / 3.0
        let imageHeight: CGFloat = scrollView.frame.height
        scrollView.contentSize = CGSize(width: CGFloat(images.count * 4) * imageWidth, height: imageHeight)

        // Create image views and labels for each image and title and add them to the scrollView in a circular arrangement
        for i in 0..<images.count * 4 {
            let circularIndex = i % images.count

            let imageView = UIImageView(image: images[circularIndex])
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(imageView)

            let titleLabel = UILabel(frame: CGRect(x: CGFloat(i) * imageWidth, y: imageHeight, width: imageWidth, height: 30))
            titleLabel.textAlignment = .center
            titleLabel.text = imageTitles[circularIndex]
            scrollView.addSubview(titleLabel)
        }

        // Start the timer to continuously move the images
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the navigation bar color to your desired color
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear // Change this to your desired color
        
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
    @objc func scrollToNextImage() {
        currentIndex += 1
        let xOffset = CGFloat(currentIndex % (images.count * 4)) * scrollView.frame.width / 3.0
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
    }
}

extension PurchaseVC: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // This method is not used for the continuous loop
    }
}
