//
//  Picture.swift
//  MindValley
//
//  Created by BqNqNNN on 1/4/20.
//  Copyright © 2020 BqNqNNN. All rights reserved.
//

import Foundation

typealias Pictures = [Picture]

struct Picture : Codable {
    let id : String
    let urls : URLS
    let user : User
}

struct URLS : Codable {
    let raw : String
    let full : String
    let regular : String
    let small : String
    let thumb : String
}

struct User : Codable {
    let id : String
    let username : String
    let name : String
}
