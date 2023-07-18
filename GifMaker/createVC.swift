//
//  createVC.swift
//  GifMaker
//
//  Created by Tipu on 18/7/23.
//

import UIKit

class createVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    let data: [(image: UIImage, title: String, description: String)] = [
        (UIImage(systemName: "house")!, "Home", "This is the home description."),
        (UIImage(systemName: "heart")!, "Favorites", "This is the favorites description."),
        (UIImage(systemName: "star")!, "Top Rated", "This is the top rated description."),
        (UIImage(systemName: "magnifyingglass")!, "Search", "This is the search description."),
        (UIImage(systemName: "person")!, "Profile", "This is the profile description."),
        (UIImage(systemName: "gear")!, "Settings", "This is the settings description.")
    ]
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("")
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! createCollectionViewCell
        let item = data[indexPath.item]
        cell.logoImage.image = item.image
        cell.logoName.text = item.title
        cell.logoDetails.text = item.description
        cell.logoDetails.numberOfLines = 0
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = (collectionView.bounds.width - 30) / 2
         return CGSize(width: width, height: 200)
     }
}
