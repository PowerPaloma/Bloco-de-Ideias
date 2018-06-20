//
//  VisualizarIdeiaViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 07/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {
    //Outlets from View
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var ideaImage: UIImageView!
    @IBOutlet var titleIdea: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet var editButton: UIButton!
    
    //Variables
    var indexIdeaSelect = 0
    var idea = Idea()
    var topicsList : [Idea] = []
//    var topicsList : [Topic] = []
    var longPressGR: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    
    //Values for UICollectionViewFlowLayout
    let inset: CGFloat = 8
    let minimunLineSpacing: CGFloat = 0
    let minimunInteritemSpacing: CGFloat = 0
    var cellsPerRow = 2
    var addCellFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Bar Large Title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //Core data
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
        collectionView.reloadData()
        
        //Topics Collection View
        let nibText = UINib(nibName: "TopicTextCollectionViewCell", bundle: nil)
        self.collectionView.register(nibText, forCellWithReuseIdentifier: "TopicCell")
        let nibImage = UINib(nibName: "TopicImageCollectionViewCell", bundle: nil)
        self.collectionView.register(nibImage, forCellWithReuseIdentifier: "TopicCell")
        let nibDraw = UINib(nibName: "TopicDrawCollectionViewCell", bundle: nil)
        self.collectionView.register(nibDraw, forCellWithReuseIdentifier: "TopicCell")
        let nibNew = UINib(nibName: "NewIdeaCollectionViewCell", bundle: nil)
        self.collectionView.register(nibNew, forCellWithReuseIdentifier: "NewTopicCell")
        
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
        
        //Edit Collection View Long Press
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        collectionView.addGestureRecognizer(longPressGR)
        longPressGR.minimumPressDuration = 0.3
        
        //Set Idea data to view
        self.ideaImage.image = UIImage(data: self.idea.image! as Data)
        self.titleIdea.text = self.idea.title
        self.descrip.text = self.idea.desc
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        editButton.setTitle("Done", for: .normal)
        setEditing(true, animated: true)
    }
    func endEditMode(){
        //Stops edit mode
        editButton.setTitle("Edit", for: .normal)
        setEditing(false, animated: true)
    }
    
    //Effects Edit Mode
    func startWigglingAllVisibleCells() {
        //Start Wiggling and Boucing effects in all cells
        let cells = collectionView!.visibleCells
        
        for cell in cells {
            if cell.reuseIdentifier == "TopicCell" {
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
    
}

extension IdeaViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicsList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            return self.collectionView.dequeueReusableCell(withReuseIdentifier: "NewTopicCell", for: indexPath) as! NewIdeaCollectionViewCell
        }else{
            //Use diferent types of cells depending on the topic type
//            if topicsList[indexPath.row-1].type == .text {
//                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicTextCollectionViewCell
//                cell.title.text = topicsList[indexPath.row-1].title
//                cell.desc.text = topicsList[indexPath.row-1].desc
//                cell.deleteButton.tag = indexPath.row-1
//                cell.delegate = self
//            }
//            if topicsList[indexPath.row-1].type == .image {
//                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicImageCollectionViewCell
//                cell.title.text = topicsList[indexPath.row-1].title
//                cell.image.image = UIImage(data: topicsList[indexPath.row-1].image!)
//                cell.deleteButton.tag = indexPath.row-1
//                cell.delegate = self
//            }
//            if topicsList[indexPath.row-1].type == .draw {
//                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicDrawCollectionViewCell
//                cell.title.text = topicsList[indexPath.row-1].title
//                cell.image.image = UIImage(data: topicsList[indexPath.row-1].image!)
//                cell.deleteButton.tag = indexPath.row-1
//                cell.delegate = self
//            }

//            if isEditing {
//                cell.startWiggling()
//            } else {
//                cell.stopWiggling()
//            }
//
//            if (indexPath as NSIndexPath) == movingIndexPath {
//                cell.alpha = 0.7
//                cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            } else {
//                cell.alpha = 1.0
//                cell.transform = CGAffineTransform.identity
//            }

            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicTextCollectionViewCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if (indexPath.row == 0){
//            performSegue(withIdentifier: "newIdea", sender: nil)
//        }else{
//            self.ideaSelected = indexPath.row - 1
//            performSegue(withIdentifier: "viewIdea", sender: nil)
//        }
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.item != 0
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt source: IndexPath, to destination: IndexPath) {

        if destination.item != 0 {
            let topic = topicsList.remove(at: source.item-1)
            topicsList.insert(topic, at: destination.item-1)

            //            collectionView.moveItem(at: destination, to: source)
            // MUDAR NO CORE DATA A ORDEM DAS IDEIAS
        }
    }
}
