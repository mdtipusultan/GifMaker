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
        case 0:
            return 4
        case 1:
            return 2
        case 2:
            return 7
        default:
            return 0 // Return 0 for any other sections
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! settingsTableViewCell
        
        // Configure the cell based on the section and row index
        switch indexPath.section {
        case 0: // Settings section
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Rate Us"
            case 1:
                cell.textLabel?.text = "Send Feddback/Crash"
            case 2:
                cell.textLabel?.text = "View Gallery"
                cell.rightMark.isHidden = true
                // Create and add the segmented control programmatically
                          let segmentedControl = UISegmentedControl(items: ["Newest First", "Oldest First"])
                          segmentedControl.selectedSegmentIndex = 0 // Set the initial selected segment index
                          segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
                          cell.accessoryView = segmentedControl // Set the segmented control as the accessory view
                // Customize the appearance of the segmented control
                segmentedControl.tintColor = .systemOrange // Set the segment's tint color
                segmentedControl.selectedSegmentTintColor = .systemOrange // Set the segment's selection color
                           segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                           segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

                         //  cell.accessoryView = segmentedControl
                         
            case 3:
                cell.textLabel?.text = "Auto Save"
                cell.rightMark.isHidden = true
                // Create and add the switch programmatically
                let switchView = UISwitch(frame: .zero)
                //switchView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                switchView.isOn = false // Set the initial state of the switch
                switchView.onTintColor = .systemOrange// Set the color of the switch when it is in the "ON" state
                switchView.thumbTintColor = .white
                switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                
                cell.accessoryView = switchView // Set the switch as the accessory view
            default:
                break
            }
        case 1: // Purchased section
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Purchase"
            case 1:
                cell.textLabel?.text = "Restore"
            default:
                break
            }
        case 2: // Others section
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Share Via Email"
            case 1:
                cell.textLabel?.text = "Share Via Instagram"
            case 2:
                cell.textLabel?.text = "Visit Our Page"
            case 3:
                cell.textLabel?.text = "Visit Our Site"
            case 4:
                cell.textLabel?.text = "Terms & Condition"
            case 5:
                cell.textLabel?.text = "Privacy Policy"
            case 6:
                cell.textLabel?.text = "About Subscription"
            default:
                break
            }
        default:
            break
        }
        cell.textLabel?.textColor = .lightGray
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // Perform the segue to the "RateUsViewController"
                //performSegue(withIdentifier: "showRateUsVC", sender: nil)
                print("showRateUsVC")
            case 1:
                // Perform the segue to the "FeedbackViewController"
                //performSegue(withIdentifier: "showFeedbackVC", sender: nil)
                print("showFeedbackVC")
            case 2:
                // Perform the segue to the "GalleryViewController"
                //performSegue(withIdentifier: "showGalleryVC", sender: nil)
                print("showGalleryVC")
            case 3:
                // Perform the segue to the "AutoSaveViewController"
                //performSegue(withIdentifier: "showAutoSaveVC", sender: nil)
                print("showAutoSaveVC")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                // Perform the segue to the "PurchaseViewController"
                //performSegue(withIdentifier: "showPurchaseVC", sender: nil)
                print("showpurchase")
            case 1:
                // Perform the segue to the "RestoreViewController"
                //performSegue(withIdentifier: "showRestoreVC", sender: nil)
                print("showRestoreVC")
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                // Perform the segue to the "ShareViaEmailViewController"
                //performSegue(withIdentifier: "showShareViaEmailVC", sender: nil)
                print("showShareViaEmailVC")
            case 1:
                // Perform the segue to the "ShareViaInstagramViewController"
                //performSegue(withIdentifier: "showShareViaInstagramVC", sender: nil)
                print("showShareViaInstagramVC")
            case 2:
                // Perform the segue to the "VisitOurPageViewController"
                //performSegue(withIdentifier: "showVisitOurPageVC", sender: nil)
                print("showVisitOurPageVC")
            case 3:
                // Perform the segue to the "VisitOurSiteViewController"
                //performSegue(withIdentifier: "showVisitOurSiteVC", sender: nil)
                print("showVisitOurSiteVC")
            case 4:
                // Perform the segue to the "TermsAndConditionViewController"
                //performSegue(withIdentifier: "showTermsAndConditionVC", sender: nil)
                print("showTermsAndConditionVC")
            case 5:
                // Perform the segue to the "PrivacyPolicyViewController"
                //performSegue(withIdentifier: "showPrivacyPolicyVC", sender: nil)
                print("showPrivacyPolicyVC")
            case 6:
                // Perform the segue to the "AboutSubscriptionViewController"
                //performSegue(withIdentifier: "showAboutSubscriptionVC", sender: nil)
                print("showAboutSubscriptionVC")
            default:
                break
            }
        default:
            break
        }
        
    }
    
    // Optional: Provide section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 30))
        label.text = sectionTitles[section]
        label.textColor = .gray // Set the text color of the header title
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //MARK: SWITCH CONTROLLING
    @objc func switchValueChanged(_ sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell,
           let indexPath = tableview.indexPath(for: cell) {
            switch indexPath.section {
            case 0: // Settings section
                switch indexPath.row {
                case 3:
                    // "Auto Save" switch value changed
                    if sender.isOn {
                        // Auto Save is enabled
                        print("Auto Save is enabled")
                    } else {
                        // Auto Save is disabled
                        print("Auto Save is disabled")
                    }
                default:
                    break
                }
                // ... (other cases)
            default:
                break
            }
        }
    }
    //MARK: SEGMENT CONTROLLING
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Get the selected segment index from the segmented control
        let selectedIndex = sender.selectedSegmentIndex

        // Perform actions based on the selected segment index
        switch selectedIndex {
        case 0:
            print("Option 1 selected")
            // Perform the action for Option 1
        case 1:
            print("Option 2 selected")
            // Perform the action for Option 2
        default:
            break
        }
    }
}
