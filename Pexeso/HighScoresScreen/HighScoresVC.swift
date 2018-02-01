//
//  HighScoresVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 25.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "maleCell"

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
        self.navigationItem.rightBarButtonItem = shareButton
        
         loadDataSource()
    }
    
    func loadDataSource() {
        //UserService.instance.deleteAllUsers()
        self.users = UserService.instance.getAllUsers()
        /*
        for user in users {
            print(user.surname)
        }
         */
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? UserTVCell else {
            print("Something wrong")
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.nameLabel.text = (user.name ?? "Empty") + " " + (user.surname ?? "Empty")
        cell.ageLabel.text = "\(user.age )"
        
        return  cell
    }
    
    // MARK: - GUI-related functionality
    
    @IBAction func userSearchFieldEditingChanged(_ sender: Any) {
        users = UserService.instance.getUsersWithNames(nameFilter: userSearchField.text)
        addUser(name: "Artem", surname: "Rieznikov", age: 32)
    }
    
    func addUser(name: String, surname: String, age: Int) {
        //UserService.instance.addUser(name: name, surname: surname, age: age)

        let user = UserService.instance.newUserMOInstance()
        user.name = name
        user.surname = surname
        user.age = Int64(age)
        
        guard UserService.instance.addEntity(entity: user, entityName: "UserMO") != nil else {
            print("Could not add object to database :-(")
            return
        }
        loadDataSource()
    }
    
    @objc func performShare() {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [
            UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
        ]
        self.present(activityVC, animated: true, completion: nil)
    }

}
