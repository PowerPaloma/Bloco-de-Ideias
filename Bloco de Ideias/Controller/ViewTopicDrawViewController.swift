//
//  ViewTopicImageViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ViewTopicDrawViewController: UIViewController {
    var viewTopic : Topic!

    @IBOutlet weak var titleTopic: UILabel!
    @IBOutlet weak var drawImageTopic: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTopic.text = viewTopic.titleT
        drawImageTopic.image = UIImage(data: viewTopic.imageT!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTopic.text = viewTopic.titleT
        drawImageTopic.image = UIImage(data: viewTopic.imageT!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "editTopicDraw", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewTopicDrawViewController {
            let vc = segue.destination as! NewTopicDrawViewController
            vc.editingTopic = viewTopic
        }
    }
    
}
