//
//  HighScoresVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 25.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class HighScoresVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(performShare))
        self.navigationItem.rightBarButtonItem = shareButton
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func performShare() {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [
            UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
        ]
        self.present(activityVC, animated: true, completion: nil)
    }

}
