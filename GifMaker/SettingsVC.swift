//
//  SettingsVC.swift
//  GifMaker
//
//  Created by Tipu on 25/7/23.
//

import UIKit

class SettingsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    let sectionTitles = ["SETTINGS", "PURCHASE", "OTHERS"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
    }
 
        
        // MARK: - Table View Data Source
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return sectionTitles.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of rows for each section
            switch section {
            case 0: // Settings section
                return 4 // For example, there are 3 rows in the "Settings" section
            case 1: // Purchased section
                return 2 // For example, there are 2 rows in the "Purchased" section
            case 2: // Others section
                return 7 // For example, there are 4 rows in the "Others" section
            default:
                return 0 // Return 0 for any other sections
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            // Configure the cell based on the section and row index
            switch indexPath.section {
            case 0: // Settings section
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Setting 1"
                case 1:
                    cell.textLabel?.text = "Setting 2"
                case 2:
                    cell.textLabel?.text = "Setting 3"
                case 3:
                    cell.textLabel?.text = "Setting 4"
                default:
                    break
                }
            case 1: // Purchased section
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Purchased Item 1"
                case 1:
                    cell.textLabel?.text = "Purchased Item 2"
                default:
                    break
                }
            case 2: // Others section
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Other Item 1"
                case 1:
                    cell.textLabel?.text = "Other Item 2"
                case 2:
                    cell.textLabel?.text = "Other Item 3"
                case 3:
                    cell.textLabel?.text = "Other Item 4"
                case 4:
                    cell.textLabel?.text = "Other Item 5"
                case 5:
                    cell.textLabel?.text = "Other Item 6"
                case 6:
                    cell.textLabel?.text = "Other Item 7"
                default:
                    break
                }
            default:
                break
            }
            cell.textLabel?.textColor = .lightGray
            return cell
        }
        
        // Optional: Provide section headers
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionTitles[section]
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
