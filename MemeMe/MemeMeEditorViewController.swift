//
//  ViewController.swift
//  MemeMe
//
//  Created by Oliver Körber on 04/07/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var shootImageButton: UIBarButtonItem!

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldHeightConstraint: NSLayoutConstraint!
    
    let defaultTopText = "top"
    let defaultBottomText = "bottom"
    
    let memeTextAttributes = [
        NSStrokeWidthAttributeName : -3.0,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        
        registerForKeyboardNotifications()

        // shootImageButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topTextField.backgroundColor = UIColor.clearColor()
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        
        bottomTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center

        let fontHeight = (topTextField.text as NSString).sizeWithAttributes(memeTextAttributes).height

        topTextFieldHeightConstraint.constant = fontHeight
        bottomTextFieldHeightConstraint.constant = fontHeight
    }
    
    func getHeightOfKeyboard(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // CGRect
        return keyboardFrame.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getHeightOfKeyboard(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getHeightOfKeyboard(notification)
    }
    
    // MARK: - Registration for Broadcasts
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions

    @IBAction func pickImageButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shootImageButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        let defaultText = (textField == topTextField) ? defaultTopText : defaultBottomText
        if textField.text == defaultText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

