//
//  OverlayViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {
    
    
    @IBOutlet weak var editButton: UIButton!
    
    
    var idea = Idea()
    var topicsList : [Topic] = []
    var longPressGR: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    var topicSelected = Topic()
    
    
    
    let inset: CGFloat = 8
    let minimunLineSpacing: CGFloat = 0
    let minimunInteritemSpacing: CGFloat = 0
    var cellsPerRow = 2
    var addCellFrame: CGRect!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.idea.title!)
        
        //Topics Collection View
        let nibText = UINib(nibName: "TopicTextCollectionViewCell", bundle: nil)
        self.collectionView.register(nibText, forCellWithReuseIdentifier: "TopicTextCell")
        let nibImage = UINib(nibName: "TopicImageCollectionViewCell", bundle: nil)
        self.collectionView.register(nibImage, forCellWithReuseIdentifier: "TopicImageCell")
        let nibDraw = UINib(nibName: "TopicDrawCollectionViewCell", bundle: nil)
        self.collectionView.register(nibDraw, forCellWithReuseIdentifier: "TopicDrawCell")
        let nibNew = UINib(nibName: "NewTopicCollectionViewCell", bundle: nil)
        self.collectionView.register(nibNew, forCellWithReuseIdentifier: "NewTopicCell")
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        //Core Data
        self.getCoreDataData()
        collectionView.reloadData()
    }
    
    func getCoreDataData() {
        //Core Data
        self.topicsList = idea.topics?.allObjects as! [Topic]
        print("Aquiii",idea.topics?.allObjects.count )
        collectionView.reloadData()
    }
    
    
    //Change layout
    @IBAction func changeLayoutAction(_ sender: Any) {
        //Change number of rows in Collection View
        if (cellsPerRow == 1) {
            cellsPerRow = 2
        } else {
            cellsPerRow = 1
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //Edit mode Action
    @IBAction func editModeAction(_ sender: Any) {
        //Starts and Stops Edit mode: reorder and delete cells
        if isEditing {
            endEditMode()
        } else {
            startEditMode()
        }
        collectionView.reloadData()
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
            let dest = segue.destination as! UINavigationController
            
            if dest.topViewController is IdeaViewController{
                let vc = dest.topViewController as! IdeaViewController
                vc.getCoreDataData()
            } else
            if dest.topViewController is ImproveIdeaViewController {
                let vc = dest.topViewController as! ImproveIdeaViewController
                vc.idea = self.idea
            } else if dest.topViewController is NewIdeaViewController{
                let vc = dest.topViewController as!NewIdeaViewController
                vc.editingIdea = idea
            }
            
        } else {
            if segue.destination is ViewTopicTextViewController{
                let vc = segue.destination as!ViewTopicTextViewController
                vc.viewTopic = self.topicSelected
            }
            else if segue.destination is ViewTopicImageViewController{
                let vc = segue.destination as!ViewTopicImageViewController
                vc.viewTopic = self.topicSelected
            }
            else if segue.destination is ViewTopicDrawViewController{
                let vc = segue.destination as!ViewTopicDrawViewController
                vc.viewTopic = self.topicSelected
                
            } else  if segue.destination is NewTopicTextViewController{
                let vc = segue.destination as!NewTopicTextViewController
                vc.idea = idea
            }
            else if segue.destination is NewTopicDrawViewController{
                let vc = segue.destination as!NewTopicDrawViewController
                vc.idea = idea
            }
            else if segue.destination is NewTopicImageViewController{
                let vc = segue.destination as!NewTopicImageViewController
                vc.idea = idea
            }
            
        }
        
        
    }
    
}



extension OverlayViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            return self.collectionView.dequeueReusableCell(withReuseIdentifier: "NewTopicCell", for: indexPath) as! NewTopicCollectionViewCell
        }else{
            //Use diferent types of cells depending on the topic type
            if topicsList[indexPath.row-1].typeT == TopicsEnum.text.rawValue {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicTextCell", for: indexPath) as! TopicTextCollectionViewCell
                cell.title.text = topicsList[indexPath.row-1].titleT
                cell.desc.text = topicsList[indexPath.row-1].descT
                cell.deleteButton.tag = indexPath.row-1
                //cell.delegate = self
                
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
            } else if topicsList[indexPath.row-1].typeT == TopicsEnum.image.rawValue {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicImageCell", for: indexPath) as! TopicImageCollectionViewCell
                cell.title.text = topicsList[indexPath.row-1].titleT
                cell.image.image = UIImage(data: topicsList[indexPath.row-1].imageT! as Data)
                cell.deleteButton.tag = indexPath.row-1
                //cell.delegate = self
                
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
            } else if topicsList[indexPath.row-1].typeT == TopicsEnum.draw.rawValue {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicDrawCell", for: indexPath) as! TopicDrawCollectionViewCell
                cell.title.text = topicsList[indexPath.row-1].titleT
                cell.image.image = UIImage(data: topicsList[indexPath.row-1].imageT! as Data)
                cell.deleteButton.tag = indexPath.row-1
                //cell.delegate = self
                
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
            } else {
                let cell2 = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicTextCollectionViewCell
                return cell2
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            //Set details of actionsheet options
            let actionSheet: UIAlertController = UIAlertController(title: "Add topic", message: "Choose an option", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let textAction = UIAlertAction(title: "Text", style: .default)
            { _ in
                self.performSegue(withIdentifier: "newTopicText2", sender: nil)
            }
            let drawAction = UIAlertAction(title: "Draw", style: .default)
            { _ in
                self.performSegue(withIdentifier: "newTopicDraw2", sender: nil)
            }
            let galeryAction = UIAlertAction(title: "Image", style: .default)
            { _ in
                self.performSegue(withIdentifier: "newTopicImage2", sender: nil)
            }
            
            //Add options to actionsheet
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(textAction)
            actionSheet.addAction(drawAction)
            actionSheet.addAction(galeryAction)
            
            //Show actionsheet
            self.present(actionSheet, animated: true, completion: nil)
        }else{
            self.topicSelected = topicsList[indexPath.row - 1]
            
            if topicSelected.typeT == TopicsEnum.text.rawValue{
                performSegue(withIdentifier: "viewTopicText2", sender: nil)
            }
            else if topicSelected.typeT == TopicsEnum.draw.rawValue{
                performSegue(withIdentifier: "viewTopicDraw2", sender: nil)
            }
            else if topicSelected.typeT == TopicsEnum.image.rawValue{
                performSegue(withIdentifier: "viewTopicImage2", sender: nil)
            }
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < -50){
            presentingViewController?.dismiss(animated: true, completion: {
                scrollView.contentOffset.y = 0
            })
            
        }
    }
}

extension OverlayViewController : UICollectionViewDelegateFlowLayout {
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

