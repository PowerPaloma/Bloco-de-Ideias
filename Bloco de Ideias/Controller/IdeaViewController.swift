//
//  VisualizarIdeiaViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 07/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {

    @IBOutlet var topicsCollection: UICollectionView!
    @IBOutlet var ideaImage: UIImageView!
    @IBOutlet var titleIdea: UILabel!
    @IBOutlet weak var descrip: UILabel!
    
    var indexIdeaSelect = 0
    
    var idea = Idea()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let entity = DataManager.getEntity(entity: "Idea")
        let query = DataManager.getAll(entity: entity)
        
        if (query.success){
            if(query.objects.count > 0){
                var ideas = query.objects as! [Idea]
                self.idea = ideas[self.indexIdeaSelect]
            }
        }else{
            NSLog("Error on reading ideas from Database...")
        }
        
        self.ideaImage.image = UIImage(data: self.idea.image!)
        self.titleIdea.text = self.idea.title
        self.descrip.text = self.idea.desc
//        self.imageProfile.layer.cornerRadius = self.imageProfile.bounds.width/2
//        self.imageProfile.layer.borderWidth = 1.0
//        self.imageProfile.layer.borderColor = UIColor.black.cgColor
//        self.imageProfile.clipsToBounds = true
//        self.descricao.sizeToFit()
        

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
