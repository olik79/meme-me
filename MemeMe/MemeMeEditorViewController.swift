//
//  ViewController.swift
//  MemeMe
//
//  Created by Oliver Körber on 04/07/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func pickImageButtonPressed(sender: UIBarButtonItem) {
        
    }
}

