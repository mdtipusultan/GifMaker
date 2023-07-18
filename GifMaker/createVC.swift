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
        (UIImage(systemName: "video")!, "Video to GIF", "You can convert your videos to gif"),
        (UIImage(systemName: "photo")!, "Photo to GIF", "You can create gifs by selecting your multiple photos"),
        (UIImage(systemName: "star")!, "GIF Editor", "You can edit or create your GIFs"),
        (UIImage(systemName: "play.circle")!, "GIF Moments", "You can create GIF from your moments"),
        (UIImage(systemName: "rectangle.compress.vertical")!, "Compress GIF", "You can compress your GIF"),
        (UIImage(systemName: "infinity.circle")!, "Loop GIF", "You can convert your capture video into Loop GIFs")
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
        let screenHeight = UIScreen.main.bounds.height
            
            // Define the reference screen height and corresponding height value
            let referenceScreenHeight: CGFloat = 926
            let referenceHeight: CGFloat = 215
            
            // Calculate the proportional height based on the current screen height
            let height = (screenHeight / referenceScreenHeight) * referenceHeight
            print(width)
            return CGSize(width: width, height: height)
         //return CGSize(width: width, height: 215)
     }
 

}
