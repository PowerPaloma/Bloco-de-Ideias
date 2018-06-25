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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var viewP: UIView!
    
    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    
    //Variables
    var idea = Idea()
    var topicsList : [Topic] = []
    var longPressGR: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    var topicSelected = Topic()
    
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()


    
    //Values for UICollectionViewFlowLayout
    let inset: CGFloat = 8
    let minimunLineSpacing: CGFloat = 0
    let minimunInteritemSpacing: CGFloat = 0
    var cellsPerRow = 2
    var addCellFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Topics Collection View
        let nibText = UINib(nibName: "TopicTextCollectionViewCell", bundle: nil)
        self.collectionView.register(nibText, forCellWithReuseIdentifier: "TopicTextCell")
        let nibImage = UINib(nibName: "TopicImageCollectionViewCell", bundle: nil)
        self.collectionView.register(nibImage, forCellWithReuseIdentifier: "TopicImageCell")
        let nibDraw = UINib(nibName: "TopicDrawCollectionViewCell", bundle: nil)
        self.collectionView.register(nibDraw, forCellWithReuseIdentifier: "TopicDrawCell")
        let nibNew = UINib(nibName: "NewIdeaCollectionViewCell", bundle: nil)
        self.collectionView.register(nibNew, forCellWithReuseIdentifier: "NewIdeaCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //Edit Collection View Long Press
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        collectionView.addGestureRecognizer(longPressGR)
        longPressGR.minimumPressDuration = 0.3
        
        //Set Idea data to view
        self.ideaImage.image = UIImage(data: self.idea.image! as Data)
        self.titleIdea.text = self.idea.title
        self.descrip.text = self.idea.desc
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(IdeaViewController.swipeUp(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Core Data
        let entityTopic = DataManager.getEntity(entity: "Topic")
        let topics = DataManager.getAll(entity: entityTopic)
        if (topics.success){
            if(topics.objects.count == 0){
                NSLog("Não existem topicos.")
            }else{
                topicsList.removeAll()
                for top in topics.objects as! [Topic] {
                    topicsList.append(top)
                }
            }
        }else{
            NSLog("Erro ao buscar topicos.")
        }
        collectionView.reloadData()
        self.ideaImage.image = UIImage(data: self.idea.image! as Data)
        self.titleIdea.text = self.idea.title
        self.descrip.text = self.idea.desc
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Navigation Bar Large Title
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
            let dest = segue.destination as! UINavigationController
            
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
            }
            if segue.identifier == "UP" {
                let overlayVC = segue.destination as UIViewController
                prepareOverlay(viewController: overlayVC)
            }
        }
        
        
    }
    
    
    //Improve Idea
    @IBAction func improveIdea(_ sender: UIButton) {
        performSegue(withIdentifier: "improve", sender: nil)
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
    @IBAction func compose(_ sender: Any) {
        performSegue(withIdentifier: "editIdea", sender: nil)
    }
    
    //teste
    
    
    
    @IBAction func swipeUp(_ recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == UISwipeGestureRecognizerDirection.up)
        {
            
//            let location = recognizer.location(in: collectionView)
//            print(location)
//            print(collectionView.contains(location as! UIFocusEnvironment))
//            if collectionView.frame.contains(location){
                let overlayViewController = storyboard?.instantiateViewController(withIdentifier: "overlayViewController") as! UIViewController
                prepareOverlay(viewController: overlayViewController)
                present(overlayViewController, animated: true)
//            }
        }
    }
    
    
    
    
    
    private func prepareOverlay(viewController: UIViewController) {
        viewController.transitioningDelegate = overlayTransitioningDelegate
        viewController.modalPresentationStyle = .custom
    }

    
}

extension IdeaViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicsList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            return self.collectionView.dequeueReusableCell(withReuseIdentifier: "NewIdeaCell", for: indexPath) as! NewIdeaCollectionViewCell
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
                self.performSegue(withIdentifier: "newTopicText", sender: nil)
            }
            let drawAction = UIAlertAction(title: "Draw", style: .default)
            { _ in
                self.performSegue(withIdentifier: "newTopicDraw", sender: nil)
            }
            let galeryAction = UIAlertAction(title: "Image", style: .default)
            { _ in
                self.performSegue(withIdentifier: "newTopicImage", sender: nil)
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
                performSegue(withIdentifier: "viewTopicText", sender: nil)
            }
            else if topicSelected.typeT == TopicsEnum.draw.rawValue{
                performSegue(withIdentifier: "viewTopicDraw", sender: nil)
            }
            else if topicSelected.typeT == TopicsEnum.image.rawValue{
                performSegue(withIdentifier: "viewTopicImage", sender: nil)
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
}

extension IdeaViewController : UICollectionViewDelegateFlowLayout {
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

//extension IdeaViewController: TopicDelegate{
//    func sendTopicToView(topic: Topic) {
//        
//    }
//    
//    
//}

