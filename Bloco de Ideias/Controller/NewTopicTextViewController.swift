//
//  NewTopicTextViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 20/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewTopicTextViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    
    var newTopicText = Topic()
    var editingTopic : Topic?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topic = editingTopic {
            self.titleTextField.text = topic.titleT
            self.descTextView.text = topic.descT
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneAction(_ sender: Any) {
        
        if (self.titleTextField.text == "" || self.descTextView.text == ""){
            let alert = UIAlertController(title: "Complete all the fields", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }else{
            if let topic = editingTopic {
                topic.titleT = self.titleTextField.text
                topic.descT = self.descTextView.text
                topic.typeT = TopicsEnum.text.rawValue
                topic.save()
                dismiss(animated: true, completion: nil)
            } else {
                self.newTopicText.titleT = self.titleTextField.text
                self.newTopicText.descT = self.descTextView.text
                self.newTopicText.typeT = TopicsEnum.text.rawValue
                DataManager.getContext().insert(self.newTopicText)
                self.newTopicText.save()
                dismiss(animated: true, completion: nil)
                
            }
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
