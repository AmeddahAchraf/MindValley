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
}

struct URLS : Codable {
    let raw : String
    let full : String
    let regular : String
    let small : String
    let thumb : String
}
