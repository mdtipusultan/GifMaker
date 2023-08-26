import UIKit
import StoreKit

class PurchaseVC: UIViewController {
    
    var currentIndex: Int = 0
    var selectedSubscriptionPlan: SubscriptionPlanType = .trial
    
    // Replace this with your actual product identifiers
    let yearlySubscriptionProductID = "com.yourapp.yearlysubscription"
    let monthlySubscriptionProductID = "com.yourapp.monthlysubscription"
    let trialSubscriptionProductID = "com.yourapp.trialsubscription"
    
    var availableProducts: [SKProduct] = [] // Define and populate this variable with available products
    
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
    
    @IBOutlet weak var yearAmountLable: UILabel!
    @IBOutlet weak var moonthAmountLable: UILabel!
    
    @IBOutlet weak var twelveMoonthLable: UILabel!
    @IBOutlet weak var sixMonthLable: UILabel!
    @IBOutlet weak var freeTrialAmountLable: UILabel!
    
    
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
        currentFormatOfAmounts()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cornerRadius: CGFloat = 10.0
        let maskPath = UIBezierPath(roundedRect: tryAndSubscribeLable.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        tryAndSubscribeLable.layer.mask = maskLayer
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
    
    //MARK: currentFormatOfAmounts
    func formatAmount(_ amount: Double, withCurrencySymbol currencySymbol: String) -> String {
        let formattedAmount = String(format: "%@%.2f", currencySymbol, amount)
        return formattedAmount
    }
    
    func currentFormatOfAmounts() {
        let currentLocale = Locale.current
        let currencySymbol = currentLocale.currencySymbol ?? ""
        
        let yearlyAmount = 18.35
        let formattedYearlyAmount = formatAmount(yearlyAmount, withCurrencySymbol: currencySymbol)
        yearAmountLable.text = "\(formattedYearlyAmount) / Year"
        
        let sixMonthlyAmount = 10.99
        let formattedSixMonthlyAmount = formatAmount(sixMonthlyAmount, withCurrencySymbol: currencySymbol)
        moonthAmountLable.text = "\(formattedSixMonthlyAmount) / 6 Months"
        
        let monthlyAmount = 4.58
        let formattedMonthlyAmount = formatAmount(monthlyAmount, withCurrencySymbol: currencySymbol)
        freeTrialAmountLable.text = "(Then \(formattedMonthlyAmount) / Month)"
        
        
        let yearlyAmountForMonths = 1.53
        let formattedYearlyAmountForMonths = formatAmount(yearlyAmountForMonths, withCurrencySymbol: currencySymbol)
        twelveMoonthLable.text = "(12 months at \(formattedYearlyAmountForMonths) / month)"
        
        let sixMonthlyAmountForMonths = 1.83
        let formattedSixMonthlyAmountForMonths = formatAmount(sixMonthlyAmountForMonths, withCurrencySymbol: currencySymbol)
        sixMonthLable.text = "(6 month at \(formattedSixMonthlyAmountForMonths) / month)"
    }
    //MARK: BUTTTONS TAPPED
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        selectedSubscriptionPlan = .yearly
        selectedPlan = .yearly
        updateButtonStates()
        tryAndSubscribeTitle.text = "Subscribe Now"
        unselectedImage.tintColor = .systemIndigo
        unselectedimage2.tintColor = .black
        selectedImage.tintColor = .black
    }
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        selectedSubscriptionPlan = .monthly
        selectedPlan = .monthly
        updateButtonStates()
        tryAndSubscribeTitle.text = "Subscribe Now"
        unselectedImage.tintColor = .black
        unselectedimage2.tintColor = .systemIndigo
        selectedImage.tintColor = .black
    }
    
    @IBAction func trailButtonTapped(_ sender: UIButton) {
        selectedSubscriptionPlan = .trial
        selectedPlan = .trial
        updateButtonStates()
        tryAndSubscribeTitle.text = "Try free & Subscribe"
        unselectedImage.tintColor = .black
        unselectedimage2.tintColor = .black
        selectedImage.tintColor = .systemIndigo
    }
    //MARK: update status of buttons
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
    @objc func scrollToNextImage() {
        currentIndex += 1
        let xOffset = CGFloat(currentIndex % (images.count * 4)) * scrollView.frame.width / 3.0
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
    }
    //MARK: Others BUTTTON TAPPED
    @IBAction func CloseButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubscribeButton(_ sender: UIButton) {
        switch selectedSubscriptionPlan {
            
        case .yearly:
            print("yearly")
            // Start the purchase process
            purchaseProduct(productID: yearlySubscriptionProductID)
            // Handle yearly subscription
        case .monthly:
            print("montthly")
            // Handle monthly subscription
            // Start the purchase process
            purchaseProduct(productID: monthlySubscriptionProductID)
        case .trial:
            print("trail")
            // Handle trial subscription
            // Start the purchase process
            purchaseProduct(productID: trialSubscriptionProductID)
        }
    }
    //MARK: In-App Purchase Methods
    func purchaseProduct(productID: String) {
        if SKPaymentQueue.canMakePayments() {
            if let product = getProductFromID(productID) {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
            } else {
                // The product with the specified productID was not found
                // Handle this case appropriately
            }
        } else {
            // In-app purchases are disabled
            // Show an alert to the user
        }
    }
    
    
    func getProductFromID(_ productID: String) -> SKProduct? {
        return availableProducts.first { product in
            product.productIdentifier == productID
        }
    }
    @IBAction func RestoreButton(_ sender: UIButton) {
    }
    
    @IBAction func TermsOfService(_ sender: UIButton) {
        if let url = URL(string: "https://www.example.com/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func PrivacyPolicy(_ sender: UIButton) {
        if let url = URL(string: "https://www.example.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func infoButtton(_ sender: UIBarButtonItem) {
        if let url = URL(string: "https://www.example.com/info") {
            UIApplication.shared.open(url)
        }
    }
    
}
//MARK: Extension
extension PurchaseVC: UIScrollViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // This method is not used for the continuous loop
    }
    
    //MARK: StoreKit Delegate Methods
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        availableProducts = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase
                // Validate receipt on server, unlock premium features, etc.
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // Handle failed purchase
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // Handle restored purchase (e.g., if user reinstalled the app)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing:
                // In-progress or deferred transaction, no action needed here
                break
            @unknown default:
                // Handle any future cases that might be added by Apple
                break
            }
        }
    }
}
enum SubscriptionPlanType {
    case yearly
    case monthly
    case trial
}
