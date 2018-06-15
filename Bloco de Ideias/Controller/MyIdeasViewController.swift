//
//  MyIdeasViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 11/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class MyIdeasViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadProcesses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        let entityIdea = DataManager.getEntity(entity: "Idea")
        let ideas = DataManager.getAll(entity: entityIdea)
        
        let entityProcess = DataManager.getEntity(entity: "Process")
        let processes = DataManager.getAll(entity: entityProcess)
        
        if (ideas.success || processes.success){
            
            if(ideas.objects.count == 0){
                NSLog("Não existem registros")
            }else{
//                for idea in ideas.objects as! [Idea] {
//                    NSLog("Nome da idea: \(idea.title ?? "")")
//                }
//                for pro in processes.objects as! [Process] {
//                    NSLog("Nome do processo: \( pro.name ?? "")")
//                }
            }
            
        }else{
            NSLog("Erro ao buscar cidades")
        }
    }
    
    
    func loadProcesses(){
        let cbl:Process = Process()
        cbl.name = "CBL"
        
        let canvas:Process = Process()
        canvas.name = "Canvas"
        
        let designThinking:Process = Process()
        designThinking.name = "Design Thinking"
        
        cbl.save()
        canvas.save()
        designThinking.save()
        
    }

}
