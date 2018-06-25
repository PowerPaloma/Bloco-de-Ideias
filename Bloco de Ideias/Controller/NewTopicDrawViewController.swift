//
//  NewTopicDrawViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 23/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewTopicDrawViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var drawView: DrawView!
    
    var newTopicDraw = Topic()
    var editingTopic : Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topic = editingTopic {
            self.titleTextField.text = topic.titleT
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if (self.titleTextField.text == ""){
            let alert = UIAlertController(title: "Complete all the fields", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }else{
            if let topic = editingTopic {
                let image_draw = drawView.getImage()
                topic.imageT = UIImageJPEGRepresentation(image_draw, 1.0)!
                topic.titleT = self.titleTextField.text
                topic.typeT = TopicsEnum.draw.rawValue
                topic.save()
                dismiss(animated: true, completion: nil)
            } else {
                let image_draw = drawView.getImage()
                self.newTopicDraw.imageT = UIImageJPEGRepresentation(image_draw, 1.0)!
                self.newTopicDraw.titleT = self.titleTextField.text
                self.newTopicDraw.typeT = TopicsEnum.draw.rawValue
                DataManager.getContext().insert(self.newTopicDraw)
                self.newTopicDraw.save()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
