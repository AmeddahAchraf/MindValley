//
//  ViewController.swift
//  MindValley
//
//  Created by BqNqNNN on 1/4/20.
//  Copyright © 2020 BqNqNNN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    // MARK : Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK : Prop
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        collectionView.contentInset = UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
        
        

    }


}


// MARK : Data source

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        
        return cell
    }
    
}

// MARK : Flow Layout

extension ViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(300)
    }
    
    
}

