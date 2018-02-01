//
//  HighScoresVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 25.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "scoreCell"

class HighScoresVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userSearchField: UITextField!
    
    var users: [UserMO] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(performShare))
        let clearAllScoresButton = UIBarButtonItem(barButtonSystemItem: .trash , target: self, action: #selector(performClearAllScores))
        self.navigationItem.rightBarButtonItems = [shareButton, clearAllScoresButton]
        
         loadDataSource()
    }
    
    func loadDataSource() {
        self.users = UserService.instance.getAllUsers()
    }
    
    // MARK: - functions that will make class conform to protocol 'UITableViewDataSource' an other table-related ones
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return users.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 90
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ScoreTVCell else {
            print("Something wrong")
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.nameLabel.text = (user.name ?? "Unknown")
        cell.cardsNumberLabel.text = "Cards pairs: \(user.cardsPairsNumber)"
        cell.scoreLabel.text = "Score: \(user.score)"
        
        return cell
    }
    
    // MARK: - GUI-related functionality
    
    @IBAction func userSearchFieldEditingChanged(_ sender: Any) {
        users = UserService.instance.getUsersWithNames(nameFilter: userSearchField.text)
        addUser(name: "Artem", cardsPairsNumber: 11, score: 32)
    }
    
    func addUser(name: String, cardsPairsNumber: Int, score: Int) {
        UserService.instance.addUser(name: name, cardsPairsNumber: cardsPairsNumber, score: score)
        loadDataSource()
    }
    
    @objc func performClearAllScores() {
        let alert = UIAlertController(title: "Do you wish to clear all high scores?", message: "This operation can not be undone", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            UserService.instance.deleteAllUsers()
            self.loadDataSource()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func performShare() {
        let screenForSharing = captureScreen()
        let activityVC = UIActivityViewController(activityItems: [screenForSharing!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [
            UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
        ]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func captureScreen() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }

}
