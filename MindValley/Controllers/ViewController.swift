//
//  ViewController.swift
//  MindValley
//
//  Created by BqNqNNN on 1/4/20.
//  Copyright © 2020 BqNqNNN. All rights reserved.
//

import UIKit
import Alamofire


// MARK: - Commmuniction Delegate Protocole

protocol DetailSelectionDelegate {
    func didTapPicture(picture :CellPicture)
}

// MARK: - Cell Properties

class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate {
    
// MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var loading: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
// MARK: - Properties
    
    var pictures : Pictures = []
    var fetchingMore : Bool = false
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
        
        CellModel.Cell_Instance.showLoading = {
            if CellModel.Cell_Instance.isLoading {
                self.activityIndicator.startAnimating()
                self.collectionView.alpha = 0.0
                self.stackView.alpha = 1.0
            } else {
                self.activityIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
                self.stackView.alpha = 0.0
            }
        }
        CellModel.Cell_Instance.showError = { error in
            print(error)
        }
        
        CellModel.Cell_Instance.reloadData = {
            self.collectionView.reloadData()
        }
        
        CellModel.Cell_Instance.fetchData(URL: BASE_URL)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func beginBatchFetched(){
        print("Fetching data")
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.fetchingMore = false
            // Fetch More Data From API
            
            //Reload Collection View when the request is done
            //self.collectionView.reloadData()
        })
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.refreshControl.endRefreshing()
            print("Refreshing")
        })
        
    }
}


// MARK: - Data source

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CellModel.Cell_Instance.cellView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.image.image = CellModel.Cell_Instance.cellView[indexPath.item].image
        cell.userNameLabel.text = CellModel.Cell_Instance.cellView[indexPath.item].userName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
        self.present(vc, animated: true, completion: nil)
        vc.selectionDelegate.didTapPicture(picture: CellPicture(image: CellModel.Cell_Instance.cellView[indexPath.item].image,
                                                                userName: CellModel.Cell_Instance.cellView[indexPath.item].userName,
                                                                largeImage: CellModel.Cell_Instance.cellView[indexPath.item].largeImage,
                                                                liked_by_user: CellModel.Cell_Instance.cellView[indexPath.item].liked_by_user,
                                                                likes: CellModel.Cell_Instance.cellView[indexPath.item].likes))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
          if !fetchingMore {
            beginBatchFetched()
          }
        }
    }
    
}

// MARK: - Flow Layout

extension ViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = CellModel.Cell_Instance.cellView[indexPath.item].image
        let height = image.size.height
        return height
    }
}


