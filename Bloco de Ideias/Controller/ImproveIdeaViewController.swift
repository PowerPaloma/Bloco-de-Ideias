//
//  ImproveIdeaViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 21/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class ImproveIdeaViewController: UIViewController {

    //Outlets from view
    @IBOutlet var answer: UITextField!
    @IBOutlet var titleSugguestion: UILabel!
    @IBOutlet var descSuggestion: UILabel!
    
    //variables
    var idea = Idea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagsOfIdea = idea.tags
        let context = DataManager.getContext()
        
        //Core Data - getting sugguestions who has the tag of this idea
        do {
            let fetchRequest : NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ANY tags.name in %@", tagsOfIdea!)
            let fetchedResults = try context.fetch(fetchRequest)
            if let aContact = fetchedResults.first {
                print("DEU CERTO")
            }
        }
        catch {
            print ("fetch task failed", error)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        if answer.text != ""{
            //tratar
        }else{
           dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func skip(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func next(_ sender: UIBarButtonItem) {
        
    }
}
