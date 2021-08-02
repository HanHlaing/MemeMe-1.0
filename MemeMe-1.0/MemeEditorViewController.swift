//
//  ViewController.swift
//  MemeMe-1.0
//
//  Created by Han Hlaing Moe on 29/07/2021.
//
import Foundation
import UIKit

class MemeEditorViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    // MARK: Variables/Constants
    
    private var imageMeme: UIImage?
    private var fontName = "Impact"
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnShare.isEnabled = false
        setUpText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(source: UIImagePickerController.SourceType.camera)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        imageMeme = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [imageMeme!], applicationActivities: nil)
        activityController.completionWithItemsHandler = { [self] (_, completed, _, _) in
            if completed {
                self.save(self.imageMeme!)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        btnShare.isEnabled = false
        setUpText()
    }
    
    @IBAction func changeFontStyle(_ sender: Any) {
        showFontActionSheet()
    }
    
    //MARK: Private methods
    
    func showFontActionSheet() {
        
        let alertController = UIAlertController(title: "Choose Font Style",
                                                message: "Please choose your desire font",
                                                preferredStyle: .actionSheet)
        
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
                let fontAction = UIAlertAction(title: font,
                                               style: .default) { _ in
                    self.fontName = font
                    self.setUpText()
                    
                }
                
                alertController.addAction(fontAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setUpText() {
    
        setupTextField(textFieldTop, text: "TOP")
        setupTextField(textFieldBottom, text: "BOTTOM")
    }
    
    private func setupTextField(_ textField: UITextField, text: String) {
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: fontName, size: 40) ?? UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -2.0
        ]
        
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func hideToolbarAndNavigationBar(hidden: Bool) {
        toolbar.isHidden = hidden
        navigationBar.isHidden = hidden
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbarAndNavigationBar(hidden: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        hideToolbarAndNavigationBar(hidden: false)
        
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
            // Create the meme
            let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    // Pick the image based on source
     private func pickAnImage(source: UIImagePickerController.SourceType) {
        
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = source
            pickerController.allowsEditing = true
            present(pickerController, animated: true, completion: nil)
        }
    
    func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if textFieldBottom.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
          view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

