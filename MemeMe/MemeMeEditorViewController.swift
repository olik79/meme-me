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
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var shootImageButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldHeightConstraint: NSLayoutConstraint!
    
    var keyboardShown: Bool = false
    
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    var loadedMeme: Meme!
    
    let memeTextAttributes = [
        NSStrokeWidthAttributeName : -3.0,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications()

        if loadedMeme != nil {
            let textTop = loadedMeme.textTop
            let textBottom = loadedMeme.textBottom
            let image = loadedMeme.image

            topTextField.text = textTop
            bottomTextField.text = textBottom
            imageView.image = image
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if loadedMeme == nil {
            shareButton.enabled = false
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            shootImageButton.enabled = false
        }
        
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        
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
        if !keyboardShown && !topTextField.isFirstResponder() {
            view.frame.origin.y -= getHeightOfKeyboard(notification)
            keyboardShown = true
            println("keyboardWillShow")
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardShown {
            view.frame.origin.y = 0
            keyboardShown = false
            println("keyboardWillHide")
        }
    }
    
    // MARK: - Meme generation
    func showBars(showBars: Bool) {
        if showBars {
            println("showing bars")
            navigationBar.hidden = false
            toolbar.hidden = false
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        } else {
            println("hiding bars")
            navigationBar.hidden = true
            toolbar.hidden = true
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        }
    }
    
    func generateMeme() -> Meme {
        return Meme(textTop: topTextField.text, textBottom: bottomTextField.text, image: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        showBars(false)
        imageView.backgroundColor = UIColor.whiteColor()
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        showBars(true)
        imageView.backgroundColor = UIColor.blackColor()
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shootImageButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonClicked(sender: UIBarButtonItem) {
        let meme = generateMeme()
        
        if let memedImage = meme.memedImage {
            let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
                if (success) {
                    self.saveMeme(self.generateMeme())
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            presentViewController(activityViewController, animated: true, completion:nil)
        }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.enabled = true
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

