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
        
        // Add the message label as a subview to the collection view's background view
             collectionview.backgroundView = messageLabel
             
             // Check if the savedGifs array is empty, and show/hide the message label accordingly
             messageLabel.isHidden = !savedGifs.isEmpty
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionview.reloadData()
    }
    //MARK: collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(savedGifs.count)
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 3
        let screenHeight = UIScreen.main.bounds.height
        
        // Define the reference screen height and corresponding height value
        let referenceScreenHeight: CGFloat = 926
        let referenceHeight: CGFloat = 100
        
        // Calculate the proportional height based on the current screen height
        let height = (screenHeight / referenceScreenHeight) * referenceHeight
        return CGSize(width: width, height: height)
    }
}
