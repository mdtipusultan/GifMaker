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
    @IBOutlet weak var offerview1: UIView!
    @IBOutlet weak var offerview2: UIView!
    @IBOutlet weak var tryAndSubscribeTitle: UILabel!
    
    
    @IBOutlet weak var yearlyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var trailButton: UIButton!
    
    @IBOutlet weak var unselectedImage: UIImageView!
    @IBOutlet weak var unselectedimage2: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    let images = [UIImage(named: "emoticon"), UIImage(named: "devil"), UIImage(named: "cool"), UIImage(named: "angry")]

    // Array of titles corresponding to each image
    let imageTitles = ["Emoticon", "Devil", "Cool", "Angry"]
    var timer: Timer?
    var selectedPlan: SubscriptionPlanType = .trial

    override func viewDidLoad() {
        super.viewDidLoad()
        gifMakerProLable.layer.cornerRadius = 10
        offerview1.layer.cornerRadius = 10
        offerview2.layer.cornerRadius = 10
        subscriptionView.layer.cornerRadius = 10
        monthView.layer.cornerRadius = 10
        yearView.layer.cornerRadius = 10
        freeView.layer.cornerRadius = 10
        let cornerRadius: CGFloat = 10.0
               let maskPath = UIBezierPath(roundedRect: tryAndSubscribeLable.bounds,
                                           byRoundingCorners: [.bottomLeft, .bottomRight],
                                           cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

               let maskLayer = CAShapeLayer()
               maskLayer.path = maskPath.cgPath
        tryAndSubscribeLable.layer.mask = maskLayer
        
        // Initialize button states
          updateButtonStates()

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
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        selectedPlan = .yearly
        updateButtonStates()
        tryAndSubscribeTitle.text = "Subscribe Now"
        unselectedImage.tintColor = .systemIndigo
        unselectedimage2.tintColor = .black
        selectedImage.tintColor = .black
    }

    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        selectedPlan = .monthly
        updateButtonStates()
        tryAndSubscribeTitle.text = "Subscribe Now"
        unselectedImage.tintColor = .black
        unselectedimage2.tintColor = .systemIndigo
        selectedImage.tintColor = .black
    }

    @IBAction func trailButtonTapped(_ sender: UIButton) {
        selectedPlan = .trial
        updateButtonStates()
        tryAndSubscribeTitle.text = "Try free & Subscribe"
        unselectedImage.tintColor = .black
        unselectedimage2.tintColor = .black
        selectedImage.tintColor = .systemIndigo
    }
    
        func updateButtonStates() {
            
            switch selectedPlan {
            case .yearly:
                unselectedImage.image = UIImage(systemName: "checkmark.circle.fill")
                unselectedimage2.image = UIImage(systemName: "circle")
                selectedImage.image = UIImage(systemName: "circle")
            case .monthly:
                unselectedImage.image = UIImage(systemName: "circle")
                unselectedimage2.image = UIImage(systemName: "checkmark.circle.fill")
                selectedImage.image = UIImage(systemName: "circle")
            case .trial:
                unselectedImage.image = UIImage(systemName: "circle")
                unselectedimage2.image = UIImage(systemName: "circle")
                selectedImage.image = UIImage(systemName: "checkmark.circle.fill")
            }
        }

    @IBAction func CloseButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
enum SubscriptionPlanType {
    case yearly
    case monthly
    case trial
}
