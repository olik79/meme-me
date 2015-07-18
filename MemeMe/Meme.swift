//
//  Meme.swift
//  MemeMe
//
//  Created by Oliver Körber on 18/07/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var textTop: String!
    var textBottom: String!
    var image: UIImage!
    var memedImage: UIImage!
    
    init(textTop: String, textBottom: String, image: UIImage, memedImage: UIImage) {
        self.textTop = textTop
        self.textBottom = textBottom
        self.image = image
        self.memedImage = memedImage
    }
}