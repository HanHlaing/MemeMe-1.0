//
//  ViewController.swift
//  MemeMe-1.0
//
//  Created by Han Hlaing Moe on 29/07/2021.
//
import Foundation
import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var pickAnImage: UIToolbar!
    
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(source: UIImagePickerController.SourceType.camera)
    }
    
    
    // Pick the image based on source
     private func pickAnImage(source: UIImagePickerController.SourceType) {
        
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = source
            pickerController.allowsEditing = true
            present(pickerController, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imagePickerView.image = image
                }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

