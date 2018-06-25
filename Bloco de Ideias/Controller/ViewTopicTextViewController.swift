//
//  ViewTopicTextViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 23/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ViewTopicTextViewController: UIViewController {

    var viewTopic: Topic?
    var index = 0
    
    @IBOutlet weak var titleTopic: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTopic.text = viewTopic!.titleT
        desc.text = viewTopic!.descT
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "editTopicText", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UINavigationController
        if dest.topViewController is NewTopicTextViewController {
            let vc = dest.topViewController as! NewTopicTextViewController
            vc.
        }
    }
}
