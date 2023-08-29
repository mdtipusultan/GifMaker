//
//  CustomTabBarController.swift
//  GifMaker
//
//  Created by Tipu on 27/7/23.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self // Set the delegate to self.
        customizeThirdTabBarItem()
    }
    
    func customizeThirdTabBarItem() {
        // Assuming you have 5 items in your tab bar, replace the index below with the correct one for the third item.
        let thirdTabIndex = 2 // (Index starts from 0, so the 3rd item is at index 2)
        
        // Set the bigger icon for the 3rd item
        if let tabBarItems = tabBar.items, tabBarItems.indices.contains(thirdTabIndex) {
            if let biggerImage = UIImage(named: "bigger_icon") {
                tabBarItems[thirdTabIndex].image = biggerImage.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Assuming you have 5 items in your tab bar, replace the index below with the correct one for the third item.
        let thirdTabIndex = 2 // (Index starts from 0, so the 3rd item is at index 2)
        
        // Check if the third tab bar item is tapped
        if tabBarController.selectedIndex == thirdTabIndex {
            openVideoOption()
        }
    }
    
    func openVideoOption() {
        // Implement code to open the video option of the device here.
        // You can use UIImagePickerController to present the video options for recording or selecting videos from the library.
        // For example:
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [UTType.movie.identifier] // Show only video options.
        present(imagePickerController, animated: true, completion: nil)
    }
}
