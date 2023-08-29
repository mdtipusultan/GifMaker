//
//  SavedVC.swift
//  GifMaker
//
//  Created by Tipu on 30/7/23.
//

import UIKit

class SavedVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionview: UICollectionView!
    // Retrieve the saved GIF data from UserDefaults
    var savedGifs: [Data] {
        let userDefaults = UserDefaults.standard
        return userDefaults.array(forKey: "savedGifs") as? [Data] ?? []
    }
    
    // Message label for displaying "You don't have any saved gif"
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have any saved gif"
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true // Initially hide the label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        // Reset the navigation bar color to the original color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) // Change this to your original color
        collectionview.reloadData()
        // Add the message label as a subview to the collection view's background view
        collectionview.backgroundView = messageLabel
        
        // Check if the savedGifs array is empty, and show/hide the message label accordingly
        messageLabel.isHidden = !savedGifs.isEmpty
    }
    @IBAction func purchaseBUttonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Purchase", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "purchaseVC")
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    func loadImages(from gifData: Data) -> [UIImage]? {
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            return nil
        }
        
        var images: [UIImage] = []
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        
        return images
    }
    //MARK: collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(savedGifs.count)
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SavedGifsCollectionViewCell
        
        // Load the GIF data from the savedGifs array
        let gifData = savedGifs[indexPath.item]
        // Convert the GIF data to images
        if let images = loadImages(from: gifData) {
            // Display the first image in the GIF as the cell's content
            cell.savedGifView.image = images.first
        } else {
            // If there was an error loading the images, display a placeholder or default image
            cell.savedGifView.image = UIImage(named: "placeholderImage")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 3
        let screenHeight = UIScreen.main.bounds.height
        
        // Define the reference screen height and corresponding height value
        let referenceScreenHeight: CGFloat = 926
        let referenceHeight: CGFloat = 128
        
        // Calculate the proportional height based on the current screen height
        let height = (screenHeight / referenceScreenHeight) * referenceHeight
        return CGSize(width: width, height: height)
    }
}
