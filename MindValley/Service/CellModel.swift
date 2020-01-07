//
//  CellModel.swift
//  MindValley
//
//  Created by BqNqNNN on 1/4/20.
//  Copyright © 2020 BqNqNNN. All rights reserved.
//

import UIKit
import Alamofire

struct CellPicture {
    let image: UIImage
    let userName : String
    let largeImage : String
    let liked_by_user : Bool
    let likes : Int
}

class CellModel {
    // MARK: Properties
    static let Cell_Instance = CellModel()
    var cellView: [CellPicture] = []
    var pictures: Pictures = [] {
        didSet {
            self.fetchPhoto()
        }
    }
   

    // MARK: UI
    var isLoading: Bool = true {
        didSet {
            showLoading?()
        }
    }
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?

    
    func fetchData(URL : String) {
        self.isLoading = true
        AF.request(URL).responseDecodable(of: Pictures.self) { response in
            switch response.result {
                
            case .success(let payload):
                self.pictures = payload
            

            case .failure(let error):
                self.showError?(error)
                print("failed")

            }
        }
    }

    private func fetchPhoto() {
        let group = DispatchGroup()
        self.pictures.forEach { (pic) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                
                let url = URL(string: pic.urls.small)
                let data = try? Data(contentsOf: url!)
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.cellView.append(CellPicture(image: image, userName: pic.user.name, largeImage: pic.urls.regular, liked_by_user: pic.liked_by_user, likes: pic.likes))
                    }
                    else{
                        print("Failed converting data")
                    }
                }
                else {
                    print("Failed getting \(pic.urls.small)")                    
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }
    
    func fetchLargePicture(URL: String, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        AF.request(URL).response{ response in
           switch response.result {
            case .success(let responseData):
                onSuccess(responseData!)

            case .failure(let error):
                onFailure(error)
            }
        }
    }


}
