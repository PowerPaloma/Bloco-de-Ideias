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
            //(ANY tags.name in %@)
            //AND (suggestionStatus.@count == 0 OR NOT (suggestionStatus.idea.title CONTAINS[cd] %@))
            //AND (%@ in processes.name)
            fetchRequest.predicate = NSPredicate(format: "(ANY processes.name == %@)"
                                                 //,tagsNames
                                                //,idea.title!
                                                    ,idea.process!.name!
            )
            
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                print("Fetched", fetchedResults.count, "suggestions")
                for sug in fetchedResults {
                    print((sug.processes) ?? "NOTHING")
                    
                    let fetchRequest2 : NSFetchRequest<SuggestionOrder> = SuggestionOrder.fetchRequest()
                    fetchRequest2.predicate = NSPredicate(format: "process.name == %@ AND suggestion.titleS == %@",
                                                         idea.process!.name!, sug.titleS!)
                    
                    let fetchedResults2 = try context.fetch(fetchRequest2)
                    if fetchedResults2.count > 0 {
                        suggestionsOrder.append((sug, fetchedResults2.first!.order))
                    } else {
                        NSLog("Error on fetch suggestion order...")
                    }
                }
                
                getRandomSuggestion()
            } else {
                NSLog("There are no suggestions for you now...")
            }
        }
        catch {
            print ("Error on reading suggestions:", error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomSuggestion(){
        self.titleSugguestion.text = suggestionsOrder[0].0.titleS
        self.descSuggestion.text = suggestionsOrder[0].0.descS
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
