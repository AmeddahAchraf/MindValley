//
//  DetailsViewController.swift
//  MindValley
//
//  Created by BqNqNNN on 1/5/20.
//  Copyright © 2020 BqNqNNN. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlet

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    
    // MARK: - Properties
    
    var selectionDelegate : DetailSelectionDelegate!
    var likedByUser = false
    var pictureDetail : CellPicture!
    var imageCashDict = NSCache<NSString, UIImage>()
    
    
    override func viewDidLoad() {
        selectionDelegate = self
        super.viewDidLoad()
        self.likedByUser = false
        likeImage.isUserInteractionEnabled = true
        likeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        }

        @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
            if !self.likedByUser {
                likeImage.image = UIImage(systemName: "heart.fill")
                likeImage.tintColor = .red
                self.likedByUser = true
                self.likeLabel.text = String(pictureDetail.likes + 1) + " Likes"
            } else {
                likeImage.image = UIImage(systemName: "heart")
                likeImage.tintColor = .black
                self.likedByUser = false
                self.likeLabel.text = String(pictureDetail.likes) + " Likes"
            }
        }
}

extension DetailsViewController : DetailSelectionDelegate {
    func didTapPicture(picture: CellPicture) {
        pictureDetail = picture
        self.image.image = picture.image
        //Adding Blur to image while downloading the real size
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.frame = self.view.bounds
        self.image.addSubview(blurredView)
        
        //Check if image has been cashed to memory
        if let img = self.imageCashDict.object(forKey: picture.largeImage as NSString)  {
            self.image.image = img
        }
        else { // Image Not cashed fetching the real size
            CellModel.Cell_Instance.fetchLargePicture(URL: picture.largeImage,
                onSuccess: { data in
                    DispatchQueue.main.async {
                        blurredView.removeFromSuperview()
                        if let image = UIImage(data: data) {
                            self.image.image = image
                            self.imageCashDict.setObject(image, forKey: picture.largeImage as NSString)
                            blurredView.removeFromSuperview()
                        }
                    }
                },
                onFailure: { error in
                    print(error)
                })
        }
        self.likeLabel.text = String(picture.likes) + " Likes"
        self.likedByUser = picture.liked_by_user
        self.userLabel.text = picture.userName
    }
    
}
