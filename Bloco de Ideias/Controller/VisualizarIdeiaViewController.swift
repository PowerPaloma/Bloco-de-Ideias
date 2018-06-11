//
//  VisualizarIdeiaViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 07/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class VisualizarIdeiaViewController: UIViewController {

    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageProfile.layer.cornerRadius = self.imageProfile.bounds.width/2
        self.imageProfile.layer.borderWidth = 1.0
        self.imageProfile.layer.borderColor = UIColor.black.cgColor
        self.imageProfile.clipsToBounds = true
        self.descricao.sizeToFit()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
