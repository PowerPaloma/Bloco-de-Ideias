//
//  NewIdeaViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 11/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewIdeaViewController: UIViewController{

    @IBOutlet var titleTF: UITextField!
    @IBOutlet var tags: UITextField!
    @IBOutlet var process: UITextField!
    @IBOutlet var desc: UITextView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var scView: UIScrollView!
    @IBOutlet var button: UIButton!
    
    var activeField: UITextField!
    //var selectedProcess: UUID
    
    var imagePicker = UIImagePickerController()
    let processPicker = UIPickerView()
    
    var processes: [Process] {
        let entity = DataManager.getEntity(entity: "Process")
        let query = DataManager.getAll(entity: entity)
        
        if (query.success){
            if(query.objects.count > 0){
                return query.objects as! [Process]
            }
            
        }else{
            NSLog("Error on reading processes from Database...")
        }
        
        return []
    }
    
    var accessoryToolbar: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTapped(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white
            return accessoryToolbar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog(processes.description)
        
        imagePicker.delegate = self
        processPicker.delegate = self
        
        process.inputView = processPicker
        process.inputAccessoryView = accessoryToolbar

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        if process.isFirstResponder {
            process.resignFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(notification: Notification){
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, targetFrame.height, 0.0)
        scView.contentInset = contentInsets
        scView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= targetFrame.height
        if (activeField != nil && !aRect.contains(activeField.frame.origin)) {
            scView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notif: Notification){
        let contentInsets = UIEdgeInsetsFromString("")
        scView.contentInset = contentInsets
        scView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
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
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galeriaAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let newIdea:Idea = Idea()
        if (self.titleTF.text == "" || self.desc.text == "" || self.process.text == "" || self.tags.text == ""){
            let alert = UIAlertController(title: "Preencha todos os campos", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }else{
            newIdea.title = self.titleTF.text
            newIdea.desc = self.desc.text
            newIdea.image = UIImageJPEGRepresentation(self.image.image!, 1.0)!
            newIdea.save()
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}

extension NewIdeaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}

extension NewIdeaViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewIdeaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return processes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return processes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.process.text = processes[row].name
    
        
    }
}
