//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 14/09/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Variables
    
    var keyboardIsShowing = false

    // Constants
    
    let topText = "TOP TEXT"
    let bottomText = "BOTTOM TEXT"
    let addText = "ADD TEXT"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 50)!,
        NSStrokeWidthAttributeName: -4.0
    ] as [String : Any]
    
    // Structs
    
    struct Meme {
        let topString: String?
        let bottomString: String?
        let originalImage: UIImage?
        let memeImage: UIImage?
    }
    
    // IBOutlets
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var movableView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // IBActions
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let shareText = "Check out this cool meme I made 😎"
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController.init(activityItems: [shareText, memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        topTextField.text = topText
        topTextField.resignFirstResponder()
        bottomTextField.text = bottomText
        bottomTextField.resignFirstResponder()
        imageView.image = nil
        shareButton.isEnabled = false
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIBarButtonItem) {
        let pickerController =  UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cameraRollButtonPressed(_ sender: UIBarButtonItem) {
        let pickerController =  UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    // ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background colour of status bar
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
        
        // Set initial appearance of textfields
        
        topTextField.delegate = self
        topTextField.text = topText
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        
        bottomTextField.delegate = self
        bottomTextField.text = bottomText
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        
        // Disable the share button initially
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        takePhotoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == topText || textField.text == bottomText || textField.text == addText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.text = addText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func presentKeyboard(_ notification: Notification) {
        switch notification.name {
        case Notification.Name.UIKeyboardWillShow:
            if !keyboardIsShowing {
                bottomTextField.frame.origin.y -= (getKeyboardHeight(notification) - 40)
                keyboardIsShowing = true
            }
        default:
            bottomTextField.frame.origin.y += (getKeyboardHeight(notification) - 40)
            keyboardIsShowing = false
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as Notification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Save and generate the meme
    
    func saveMeme() -> Meme {
        let savedMeme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalImage: imageView.image!, memeImage: generateMemedImage())
        return savedMeme
    }
    
    func generateMemedImage() -> UIImage {
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        let crop = CGRect(x: 0, y: (navigationBar.frame.height + CGFloat(20)), width: self.view.frame.width, height: memedImage.size.height - (navigationBar.frame.height + toolBar.frame.height + CGFloat(20)))
        let croppedImage = memedImage.cgImage!.cropping(to: crop)
        
        return UIImage(cgImage: croppedImage!)
    }
}

