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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailsViewController : DetailSelectionDelegate {
    
    func didTapPicture(picture: CellPicture) {
        pictureDetail = picture
        self.image.image = picture.image
        //Adding Blur to image while downloading the real size
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.frame = self.view.bounds
        self.image.addSubview(blurredView)
        //Fetch real size image
        CellModel.Cell_Instance.fetchLargePicture(URL: picture.largeImage,
            onSuccess: { data in
                DispatchQueue.main.async {
                    blurredView.removeFromSuperview()
                    self.image.image = UIImage(data: data, scale:1)
                }
                                                
        },
            onFailure: { error in
                print(error)
        })
        self.likeLabel.text = String(picture.likes) + " Likes"
        self.likedByUser = picture.liked_by_user
        self.userLabel.text = picture.userName
    }
    
}
