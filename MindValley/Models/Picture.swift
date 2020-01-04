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

enum URLS : String , Codable {
    case raw, full, regular, small, thumb
}
