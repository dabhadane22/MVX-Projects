//
//  ImagePickerManager.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/14/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)

    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        
        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = self.viewController?.view
//       //     alert.popoverPresentationController?.sourceRect =
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//
        
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
      //  alert.popoverPresentationController?.sourceView = self.viewController!.view
        
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"Cancel")
            alertWarning.show()
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
 /*       let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
        }))
        
        self.viewController?.present(alert, animated: true, completion: nil)
*/
        
        pickImageCallback?(image)
        
         picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?)
    {
        
    }
    
}
