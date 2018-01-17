//
//  GameVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 17.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
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
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CardCollectionViewCell else {
            fatalError("Oops: can not get the proper cell CardCollectionViewCell")
        }
        
        // Configure the cell
        
        cell.cardButton?.setImage(#imageLiteral(resourceName: "i14"), for: UIControlState.normal)
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.red.cgColor
        
        // TODO: this is not working since cardButton is nil
        // cell.cardButton.addTarget(self, action: #selector(cardBtnClicked), for: UIControlEvents.touchUpInside)
        
        return cell
    }

}
