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
    var previousViewController: UIViewController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = self.meme.memedImage
    }
    
    @IBAction func editButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editorController = storyboard.instantiateViewControllerWithIdentifier("Meme Editor") as!MemeMeEditorViewController
        
        editorController.loadedMeme = self.meme
        
        previousViewController.presentViewController(editorController, animated: false, completion: nil)
    }
}
