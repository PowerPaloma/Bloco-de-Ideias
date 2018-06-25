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
    var suggestionsOrder: [(Suggestion,Int64)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagsNames = idea.tags!.map{ ($0 as! Tag).name! }
        let context = DataManager.getContext()
        
        //Core Data - getting suggestions who has the tag of this idea
        do {
            let fetchRequest : NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
            //AND (suggestionStatus.@count == 0 OR NOT (suggestionStatus.idea.title CONTAINS[cd] %@))
            fetchRequest.predicate = NSPredicate(format: "(ANY tags.name in %@) AND (%@ in processes.name)",
                                                 tagsNames //,idea.title!
                                                    ,idea.process!.name!
            )
            
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                for sug in fetchedResults {
                    print(sug.titleS!)
                    
                    let fetchRequest2 : NSFetchRequest<SuggestionOrder> = SuggestionOrder.fetchRequest()
                    fetchRequest2.predicate = NSPredicate(format: "process.name == %@ AND suggestion.titleS == %@",
                                                         idea.process!.name!, sug.titleS!)
                    
                    let fetchedResults2 = try context.fetch(fetchRequest2)
                    if fetchedResults2.count > 0 {
                        print(fetchedResults2.count)
                        
                        suggestionsOrder.append((sug, fetchedResults2.first!.order))
                    }
                }
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        
        self.titleSugguestion.text = suggestionsOrder[0].0.titleS
        self.descSuggestion.text = suggestionsOrder[0].0.descS
//
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
