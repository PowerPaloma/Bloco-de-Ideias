//  NewTopicImageViewController.swift
//
//  Bloco de Ideias
//
//  Created by Ada 2018 on 20/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewTopicImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    var imagePicker = UIImagePickerController()
    
    var flag: Bool = false
    var newTopicImage = Topic()
    var editingTopic : Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Set imagepicker delegate to self
        imagePicker.delegate = self
        
        if let topic = editingTopic {
            self.titleTextField.text = topic.titleT
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Show ActionSheet
        if !flag{
            self.showAlert()
            flag = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        showAlert()
    }
    
    
    
    @IBAction func doneAction(_ sender: Any) {
        if (self.titleTextField.text == "" || self.image.image == nil){
            let alert = UIAlertController(title: "Complete all the fields", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }else{
            if let topic = editingTopic {
                topic.titleT = self.titleTextField.text
                topic.imageT = UIImageJPEGRepresentation(self.image.image!, 1.0)!
                topic.typeT = TopicsEnum.image.rawValue
                topic.save()
                dismiss(animated: true, completion: nil)
            } else {
                self.newTopicImage.titleT = self.titleTextField.text
                self.newTopicImage.imageT = UIImageJPEGRepresentation(self.image.image!, 1.0)!
                self.newTopicImage.typeT = TopicsEnum.image.rawValue
                DataManager.getContext().insert(self.newTopicImage)
                self.newTopicImage.save()
                dismiss(animated: true, completion: nil)
            }

        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(){
        //Set details of actionsheet options
        let actionSheet: UIAlertController = UIAlertController(title: "Capture an image", message: "Choose an option", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        { _ in
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) else {
                let alert: UIAlertController = UIAlertController(title: "Oops...", message: "Camera is not available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let galeriaAction = UIAlertAction(title: "Library", style: .default)
        { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        //Add options to actionsheet
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galeriaAction)
        
        //Show actionsheet
        self.present(actionSheet, animated: true, completion: nil)
        //self.present(actionSheet, animated: true, completion: nil)
    }
}

extension NewTopicImageViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    //Get the selected image and put it in the UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Handle cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
