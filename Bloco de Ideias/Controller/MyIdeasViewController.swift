//
//  MyIdeasViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 11/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//
import CoreData
import UIKit

class MyIdeasViewController: UIViewController {
    //Outlets from View
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    //Variables
    var longPressGR: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    var ideasList : [Idea] = []
    var processList : [Process] = []
    var indexIdeaSelected = 0
    
    //Values for UICollectionViewFlowLayout
    let inset: CGFloat = 8
    let minimunLineSpacing: CGFloat = 0
    let minimunInteritemSpacing: CGFloat = 0
    var cellsPerRow = 2
    var addCellFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Ideas Collection View
        let nib = UINib(nibName: "MyIdeaCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MyIdeaCell")
        let nibNew = UINib(nibName: "NewIdeaCollectionViewCell", bundle: nil)
        self.collectionView.register(nibNew, forCellWithReuseIdentifier: "NewIdeaCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //Edit Collection View Long Press
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        collectionView.addGestureRecognizer(longPressGR)
        longPressGR.minimumPressDuration = 0.3
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Core Data
        let entityIdea = DataManager.getEntity(entity: "Idea")
        let ideas = DataManager.getAll(entity: entityIdea)
        let entityProcess = DataManager.getEntity(entity: "Process")
        let processes = DataManager.getAll(entity: entityProcess)
        
        if (ideas.success || processes.success){
            if(ideas.objects.count == 0){
                NSLog("Não existem registros.")
            }else{
                ideasList.removeAll()
                for idea in ideas.objects as! [Idea] {
                    ideasList.append(idea)
                }
                processList.removeAll()
                for process in processes.objects as! [Process] {
                    processList.append(process)
                }
            }
        }else{
            NSLog("Erro ao buscar registros.")
        }
        collectionView.reloadData()
    }
    
    //Delete all ideas
    @IBAction func deleteAllData(_ sender: UIBarButtonItem) {
        DataManager.deleteAll(entity: Tag.entityDescription())
        DataManager.deleteAll(entity: Process.entityDescription())
        DataManager.deleteAll(entity: Topic.entityDescription())
        DataManager.deleteAll(entity: Idea.entityDescription())
        DataManager.deleteAll(entity: SuggestionStatus.entityDescription())
        DataManager.deleteAll(entity: SuggestionOrder.entityDescription())
        DataManager.deleteAll(entity: Suggestion.entityDescription())
    }
    
    //Change layout: number of rows
    @IBAction func changeLayoutAction(_ sender: Any) {
        //Change number of rows in Collection View
        if (cellsPerRow == 1) {
            cellsPerRow = 2
        } else {
            cellsPerRow = 1
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //Edit mode collection view
    @IBAction func editModeAction(_ sender: Any) {
        //Starts and Stops Edit mode: reorder and delete cells
        if isEditing {
            endEditMode()
        } else {
            startEditMode()
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        //Starts and end editing mode
        super.setEditing(editing, animated: true)
        startWigglingAllVisibleCells()
    }
    func startEditMode(){
        //Starts edit mode
        editButton.title = "Done"
        setEditing(true, animated: true)
    }
    func endEditMode(){
        //Stops edit mode
        editButton.title = "Edit"
        setEditing(false, animated: true)
    }
    
    //Effects Edit Mode
    func startWigglingAllVisibleCells() {
        //Start Wiggling and Boucing effects in all cells
        let cells = collectionView!.visibleCells
        
        for cell in cells {
            if cell.reuseIdentifier == "MyIdeaCell" {
                let c = cell as! MyIdeaCollectionViewCell
                if isEditing {
                    c.startWiggling()
                } else {
                    c.stopWiggling()
                } } }
    }
    
    //Reordering Cells
    func pickedUpCell() -> MyIdeaCollectionViewCell? {
        //Return selected cell when longpressed
        guard let indexPath = movingIndexPath else { return nil }
        return collectionView.cellForItem(at: indexPath as IndexPath) as? MyIdeaCollectionViewCell
    }
    
    func animatePickingUpCell(cell: MyIdeaCollectionViewCell?) {
        //Animates the cell when longpress starts
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.alpha = 0.7
            cell?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { finished in
            NSLog("animatePickingUpCell")
        })
    }
    
    func animatePuttingDownCell(cell: MyIdeaCollectionViewCell?) {
        //Animates the cell when longpress ends
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.alpha = 1.0
            cell?.transform = CGAffineTransform.identity
        }, completion: { finished in
            cell?.startWiggling()
            NSLog("animatePickingDownCell")
        })
    }
    
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        //Get the longpress gesture and handle the reorder the cells based in it's location
        let location = gesture.location(in: collectionView)
        if let locationIndexPathForItem = collectionView.indexPathForItem(at: location) {
           movingIndexPath = locationIndexPathForItem as NSIndexPath
        }
        //LongPress starts
        if gesture.state == .began {
            guard let indexPath = movingIndexPath else { return }
            addCellFrame = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))?.frame

            setEditing(true, animated: true)
            startEditMode()
            
            collectionView.beginInteractiveMovementForItem(at: indexPath as IndexPath)
            pickedUpCell()?.stopWiggling()
            animatePickingUpCell(cell: pickedUpCell())
        }
        //Longpress changes
        else if(gesture.state == .changed) {
            collectionView.updateInteractiveMovementTargetPosition(location)
        }
        //Longpress ends
        else {
            if gesture.state == .ended &&
                collectionView.cellForItem(at: IndexPath(item: 0, section: 0))?.frame == addCellFrame &&
                !addCellFrame.contains(location)
                {
                collectionView.endInteractiveMovement()
            } else{
                collectionView.cancelInteractiveMovement()
            }
            animatePuttingDownCell(cell: pickedUpCell())
            movingIndexPath = nil
        }
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is IdeaViewController{
           let vc = segue.destination as! IdeaViewController
            vc.idea = self.ideasList[self.indexIdeaSelected]
        }
    }
}

extension MyIdeasViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ideasList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            return self.collectionView.dequeueReusableCell(withReuseIdentifier: "NewIdeaCell", for: indexPath) as! NewIdeaCollectionViewCell
        }else{
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MyIdeaCell", for: indexPath) as! MyIdeaCollectionViewCell
            
            cell.title.text = ideasList[indexPath.row-1].title
            cell.desc.text = ideasList[indexPath.row-1].desc
            cell.image.image = UIImage(data: ideasList[indexPath.row-1].image! as Data)
            cell.deleteButton.tag = indexPath.row-1
            cell.delegate = self
            
            if isEditing {
                cell.startWiggling()
            } else {
                cell.stopWiggling()
            }
            
            if (indexPath as NSIndexPath) == movingIndexPath {
                cell.alpha = 0.7
                cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            } else {
                cell.alpha = 1.0
                cell.transform = CGAffineTransform.identity
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            performSegue(withIdentifier: "newIdea", sender: nil)
        }else{
            self.indexIdeaSelected = indexPath.row - 1
            performSegue(withIdentifier: "viewIdea", sender: nil)
        }
        collectionView.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.item != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt source: IndexPath, to destination: IndexPath) {
        
        if destination.item != 0 {
            let idea = ideasList.remove(at: source.item-1)
            ideasList.insert(idea, at: destination.item-1)
            
//            collectionView.moveItem(at: destination, to: source)
            // MUDAR NO CORE DATA A ORDEM DAS IDEIAS
        }
    }
}

extension MyIdeasViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimunLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimunInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimunInteritemSpacing * CGFloat(cellsPerRow - 1)
        
        let itemWidth = ((view.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow).rounded(.down))

        return CGSize(width: itemWidth, height: 160.0)
    }
}

extension MyIdeasViewController : IdeaDelegate {
    func deleteIdea(item: Int) {
        let alertSave = UIAlertController(title: "Delete Idea?", message: "Are you sure you want to delete this idea?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "Yes", style: .default  , handler: {_ in
            let idea = self.ideasList.remove(at: item)
            idea.delete()
            
            let indexPath = IndexPath(item: item+1, section: 0)
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            }) { (finished) in
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            }
        })
        
        alertSave.addAction(cancelButton)
        alertSave.addAction(yesButton)
        
        self.present(alertSave, animated: true, completion: nil)
    }
}


