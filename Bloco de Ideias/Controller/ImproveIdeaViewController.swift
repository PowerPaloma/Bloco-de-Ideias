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
    @IBOutlet var createTopic: UISwitch!
    @IBOutlet var image: UIImageView!
    
    //variables
    var idea = Idea()
    var suggestionsOrder: [(Suggestion,Int64)] = []
    var notAnswered: [(Suggestion,Int64)] = []
    var answered: [(Suggestion,Int64)] = []
    var filteredByOrd: [(Suggestion,Int64)] = []
    var currentSugg: (Suggestion, Int64) = (Suggestion(), 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagsNames = idea.tags!.map{ ($0 as! Tag).name! }
        let context = DataManager.getContext()
        
        //Core Data - getting suggestions who has the tag of this idea
        do {
            let fetchRequest : NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
            // AND (suggestionStatus.@count == 0 OR NOT (ANY suggestionStatus.idea.title =[cd] %@))
            fetchRequest.predicate = NSPredicate(format:"(ANY tags.name in %@) AND (ANY processes.name in %@)"
                                               ,tagsNames
                                                ,[idea.process!.name!]
//                                               ,idea.title!
         )

            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                print("Fetched", fetchedResults.count, "suggestions")
                for sug in fetchedResults {
                    
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
                
                notAnswered = suggestionsOrder.filter({ (sug,_) -> Bool in
                    !self.isAnswered(sug)
                })
                
                answered = suggestionsOrder.filter({ (sug,_) -> Bool in
                    self.isAnswered(sug)
                })
                
                filteredByOrd = notAnswered.filter { (_, ord) -> Bool in
                    answered.filter({ (_, ord2) -> Bool in
                        ord2 == ord - 1
                    }).count >= 2 || ord == 0
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
    
    func isAnswered(_ sug: Suggestion) -> Bool {
        // verifica se a idea está incluída no conjunto das ideias que respodeu a sugestão
        return (sug.suggestionStatus?.reduce(false, { (r, sugStat) -> Bool in
            r || (sugStat as! SuggestionStatus).idea?.title == self.idea.title
        }))!
    }
    
    func getRandomSuggestion(){
        if(!filteredByOrd.isEmpty){
            currentSugg = filteredByOrd.remove(at: Int(arc4random_uniform(UInt32(filteredByOrd.count))))
            self.titleSugguestion.text = currentSugg.0.titleS
            self.descSuggestion.text = currentSugg.0.descS
        }else{
            let alertSheet: UIAlertController = UIAlertController(title: "Out of suggestions",
                                                                  message: "According to your creative process and tags, we don't have more suggestions at the moment.\nNow you may be prepared to put your idea into practice!",
                                                                  preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            
            alertSheet.addAction(okAction)
            
            self.present(alertSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        if answer.text != ""{
            //tratar
        }else{
           dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func next(_ sender: UIBarButtonItem) {
        let context = DataManager.getContext()
        
        if answer.text != "" {
            // check done in suggestion
            let status = SuggestionStatus()
            status.done = true
            context.insert(status)
            status.idea = self.idea
            status.suggestion = self.currentSugg.0
            status.save()
            
            if createTopic.isOn {
                // create topic in idea for the answer
                let newTopic = Topic()
                newTopic.titleT = self.currentSugg.0.topicTitle
                newTopic.descT = self.answer.text
                newTopic.typeT = TopicsEnum.text.rawValue
                context.insert(newTopic)
                newTopic.idea = self.idea
                newTopic.save()
            }
            self.getRandomSuggestion()
        } else {
            let aux = currentSugg
            self.getRandomSuggestion()
            filteredByOrd.append(aux)
        }
        
    }
}
