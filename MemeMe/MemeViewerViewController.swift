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
    var memeIndex: Int!
    var previousViewController: UIViewController!
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        
        imageView.image = self.meme.memedImage
    }
    
    @IBAction func editButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editorController = storyboard.instantiateViewControllerWithIdentifier("Meme Editor") as! MemeMeEditorViewController
        
        editorController.loadedMeme = self.meme
        
        previousViewController.presentViewController(editorController, animated: false, completion: nil)
    }
    
    @IBAction func deleteButtonClicked(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.removeAtIndex(memeIndex)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
