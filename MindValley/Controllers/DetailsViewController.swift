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
    
    func storeImage(urlString : String, img : UIImage) {
        print("Cashing")
        let tmpPath = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: tmpPath)
        
        let data = img.jpegData(compressionQuality: 0.5)
        try? data?.write(to : url)
        
        var dict = UserDefaults.standard.object(forKey: urlString) as? [String : String]
        if dict == nil {
            dict = [String : String]()
        }
        dict![urlString] = tmpPath
        UserDefaults.standard.set(dict, forKey: urlString)
        
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
        
        
        if let dict = UserDefaults.standard.object(forKey: picture.largeImage) as? [String : String] {
            //Image Cashed
            if let path = dict[picture.largeImage] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                    let image = UIImage(data: data)
                    blurredView.removeFromSuperview()
                    self.image.image = image
                }
            }
        }
        else { // Image Not cashed fetching the real size
            CellModel.Cell_Instance.fetchLargePicture(URL: picture.largeImage,
                onSuccess: { data in
                    DispatchQueue.main.async {
                        blurredView.removeFromSuperview()
                        if let image = UIImage(data: data) {
                            self.image.image = image
                            self.storeImage(urlString: picture.largeImage, img: image)
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
