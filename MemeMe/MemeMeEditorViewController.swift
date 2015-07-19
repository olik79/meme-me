//
//  ViewController.swift
//  MemeMe
//
//  Created by Oliver Körber on 04/07/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var shootImageButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldHeightConstraint: NSLayoutConstraint!
    
    var keyboardShown: Bool = false
    
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
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

    }
    
    override func viewWillDisappear(animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        shareButton.enabled = false
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            shootImageButton.enabled = false
        }
        
        topTextField.backgroundColor = UIColor.clearColor()
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
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
        if !self.keyboardShown {
            view.frame.origin.y -= getHeightOfKeyboard(notification)
            self.keyboardShown = true
            println("keyboardWillShow")
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.keyboardShown {
            view.frame.origin.y += getHeightOfKeyboard(notification)
            self.keyboardShown = false
            println("keyboardWillHide")
        }
    }
    
    // MARK: - Meme generation
    func showBars(showBars: Bool) {
        if showBars {
            println("showing bars")
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.toolbar.hidden = false
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        } else {
            println("hiding bars")
            self.navigationController?.popToRootViewControllerAnimated(false)
            self.toolbar.hidden = true
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        }
    }
    
    func generateMeme() -> Meme {
        return Meme(textTop: topTextField.text, textBottom: bottomTextField.text, image: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        showBars(false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        showBars(true)
        return memedImage
    }
    
    func saveMeme(meme: Meme) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.memes.append(meme)
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
    
    @IBAction func shareButtonClicked(sender: UIBarButtonItem) {
        let meme = self.generateMeme()
        
        if let memedImage = meme.memedImage {
            let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.shareButton.enabled = true
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newString: NSString = textField.text
        newString = newString.stringByReplacingCharactersInRange(range, withString: string)
        newString = newString.uppercaseString

        textField.text = newString as String
        return false
    }
}

