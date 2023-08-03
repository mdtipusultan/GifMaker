//
//  PurchaseVC.swift
//  GifMaker
//
//  Created by Tipu on 2/8/23.
//

import UIKit

class PurchaseVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var gifMakerProLable: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.dataSource = self
        collectionview.delegate = self
        
        gifMakerProLable.layer.cornerRadius = 10
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
    //MARK: collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! purchaseCollectionViewCell
        switch indexPath.row {
         case 0:
             cell.imagesOfMoving.image = UIImage(named: "emoticon") // Set your image name here
         case 1:
             cell.imagesOfMoving.image = UIImage(named: "devil") // Set your image name here
         case 2:
             cell.imagesOfMoving.image = UIImage(named: "cool") // Set your image name here
         case 3:
             cell.imagesOfMoving.image = UIImage(named: "angry") // Set your image name here
         default:
             cell.imagesOfMoving.image = nil // Set a default image or nil if needed
         }
        return cell
    }

}
