//
//  MemeViewerViewController.swift
//  MemeMe
//
//  Created by Oliver Körber on 24/07/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import UIKit

class MemeViewerViewController: UIViewController {
    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = self.meme.memedImage
    }
}
