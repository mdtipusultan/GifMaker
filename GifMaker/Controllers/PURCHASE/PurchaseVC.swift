//
//  PurchaseVC.swift
//  GifMaker
//
//  Created by Tipu on 2/8/23.
//

import UIKit

class PurchaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //navigationController?.navigationBar.backgroundColor = UIColor.green
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
    
}
