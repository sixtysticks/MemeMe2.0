//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 14/09/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Variables
    
    var currentImagePicked = CGRect()

    // MARK: Constants
    
    let topText = "TOP TEXT"
    let bottomText = "BOTTOM TEXT"
    let addText = "ADD TEXT"
    let topConstantDefault: CGFloat = 56
    let bottomConstantDefault: CGFloat = -56
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 50)!,
        NSStrokeWidthAttributeName: -4.0
    ] as [String : Any]
    
    // MARK: IBOutlets
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextfieldConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldConstraintBottom: NSLayoutConstraint!

    // MARK: IBActions
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create text to accompany the generated meme
        let shareText = "Check out this cool meme I made 😎"
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController.init(activityItems: [shareText, memedImage], applicationActivities: nil)
        
        // Save the meme on completion of share
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if(success){
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
//        // Set UI elements back to default
//        topTextField.text = topText
//        bottomTextField.text = bottomText
//        topTextField.resignFirstResponder()
//        bottomTextField.resignFirstResponder()
//        imageView.image = nil
//        shareButton.isEnabled = false
//        updateTextFieldConstraints(topConstantDefault, bottomConstant: bottomConstantDefault)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIBarButtonItem) {
        presentImagePicker(.camera)
    }
    
    @IBAction func cameraRollButtonPressed(_ sender: UIBarButtonItem) {
        presentImagePicker(.photoLibrary)
    }
    
    func presentImagePicker(_ sourceType: UIImagePickerControllerSourceType) {
        let pickerController =  UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields(topTextField, text: topText)
        setupTextFields(bottomTextField, text: bottomText)
        
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
    
    func setupTextFields(_ textfield: UITextField, text: String) {
        textfield.delegate = self
        textfield.text = text
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Clear text if it hasn't been changed from default
        if textField.text == topText || textField.text == bottomText || textField.text == addText {
            textField.text = ""
        }
        
        // Unsubscribe if editing toptextfield, as we don't need the view to move
        if textField.tag == 0 {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Add default text if textfield has been tapped into, but not edited
        if (textField.text?.isEmpty)! {
            textField.text = addText
        }
        
        // Subscribe back to notifications on top textfield when editing ends
        if textField.tag == 0 {
            subscribeToKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
            
            currentImagePicked = calculateImageProportions(imageView: imageView)
        
            // Update constraints to position textfields in correct positions over image
            updateTextFieldConstraints((currentImagePicked.origin.y + 10), bottomConstant: -(currentImagePicked.origin.y + 6))
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func calculateImageProportions(imageView: UIImageView) -> CGRect {
        let imgViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        let scaleWidth = imgViewSize.width / (imgSize?.width)!
        let scaleHeight = imgViewSize.height / (imgSize?.height)!
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imgRect = CGRect(x: 0, y: 0, width: (imgSize?.width)! * aspect, height: (imgSize?.height)! * aspect)
        
        imgRect.origin.x = (imgViewSize.width - imgRect.size.width) / 2
        imgRect.origin.y = (imgViewSize.height - imgRect.size.height) / 2
        
        imgRect.origin.x += imageView.frame.origin.x
        imgRect.origin.y += imageView.frame.origin.y
        
        return imgRect
    }
    
    // MARK: Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // MARK: Custom functions
    
    func presentKeyboard(_ notification: Notification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func dismissKeyboard(_ notification: Notification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as Notification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func deviceRotated(_ notification: Notification) {
        if (UIDeviceOrientationIsLandscape(UIDevice.current.orientation) || currentImagePicked.isEmpty) {
            updateTextFieldConstraints(topConstantDefault, bottomConstant: bottomConstantDefault)
        } else {
            updateTextFieldConstraints((currentImagePicked.origin.y + 10), bottomConstant: -(currentImagePicked.origin.y + 6))
        }
    }
    
    func updateTextFieldConstraints(_ topConstant: CGFloat, bottomConstant: CGFloat) {
        NSLayoutConstraint.deactivate([topTextfieldConstraintTop, bottomTextFieldConstraintBottom])
        
        // Add new constraints based on size and position of picked image
        let newTopAnchor = topTextField.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: topConstant)
        let newBottomAnchor = bottomTextField.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: bottomConstant)
        
        topTextfieldConstraintTop = newTopAnchor
        bottomTextFieldConstraintBottom = newBottomAnchor
        
        NSLayoutConstraint.activate([topTextfieldConstraintTop, bottomTextFieldConstraintBottom])
    }
    
    func saveMeme() {
        let meme = Meme(topString: topTextField.text!,
                 bottomString: bottomTextField.text!,
                 originalImage: imageView.image!,
                 memeImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        configureBars(barsHidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(barsHidden: false)
        
        let crop = CGRect(x: currentImagePicked.origin.x, y: currentImagePicked.origin.y, width: currentImagePicked.width, height: currentImagePicked.height)
        let croppedImage = memedImage.cgImage!.cropping(to: crop)
        
        return UIImage(cgImage: croppedImage!)
    }
    
    func configureBars(barsHidden: Bool) {
        navigationBar.isHidden = barsHidden
        toolBar.isHidden = barsHidden
    }
}

