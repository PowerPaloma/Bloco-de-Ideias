//
//  MyIdeasViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 11/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class MyIdeasViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var longPressGR: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    var ideasList : [Idea] = []
    var processList : [Process] = []
    
    let inset: CGFloat = 16
    let minimunLineSpacing: CGFloat = 16
    let minimunInteritemSpacing: CGFloat = 16
    var cellsPerRow = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MyIdeaCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MyIdeaCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //-------------- view did load---------------
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        collectionView.addGestureRecognizer(longPressGR)
        longPressGR.minimumPressDuration = 0.3
        //-----------------------------
        
        self.loadProcesses()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
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
                NSLog("Não existem registros.")
            }else{
                for idea in ideas.objects as! [Idea] {
                    ideasList.append(idea)
                }
                for process in processes.objects as! [Process] {
                    processList.append(process)
                }
            }
        }else{
            NSLog("Erro ao buscar registros.")
        }
        collectionView.reloadData()
    }
    
    @IBAction func changeLayoutAction(_ sender: Any) {
        if (cellsPerRow == 1) {
            cellsPerRow = 2
        } else {
            cellsPerRow = 1
        }
        collectionView.collectionViewLayout.invalidateLayout()
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
    
    
    //-------------- view controler ---------------
    func pickedUpCell() -> MyIdeaCollectionViewCell? {
        guard let indexPath = movingIndexPath else { return nil }
        
        return collectionView.cellForItem(at: indexPath as IndexPath) as? MyIdeaCollectionViewCell
    }
    
    func animatePickingUpCell(cell: MyIdeaCollectionViewCell?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.alpha = 0.7
            cell?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { finished in
            
        })
    }
    
    func animatePuttingDownCell(cell: MyIdeaCollectionViewCell?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.alpha = 1.0
            cell?.transform = CGAffineTransform.identity
        }, completion: { finished in
            cell?.startWiggling()
        })
    }
    
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        if let locationIndexPathForItem = collectionView.indexPathForItem(at: location) {
           movingIndexPath = locationIndexPathForItem as NSIndexPath
        }

        if gesture.state == .began {
            guard let indexPath = movingIndexPath else { return }
            
            setEditing(true, animated: true)
            collectionView.beginInteractiveMovementForItem(at: indexPath as IndexPath)
            pickedUpCell()?.stopWiggling()
            animatePickingUpCell(cell: pickedUpCell())
        } else if(gesture.state == .changed) {
            collectionView.updateInteractiveMovementTargetPosition(location)
        } else {
            gesture.state == .ended
                ? collectionView.endInteractiveMovement()
                : collectionView.cancelInteractiveMovement()
            
            animatePuttingDownCell(cell: pickedUpCell())
            movingIndexPath = nil
        }
    }
    
    func startWigglingAllVisibleCells() {
        let cells = collectionView?.visibleCells as! [MyIdeaCollectionViewCell]
        
        for cell in cells {
            if isEditing { cell.startWiggling() } else { cell.stopWiggling() }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        startWigglingAllVisibleCells()
    }
    
    //-----------------------------
}

extension MyIdeasViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ideasList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MyIdeaCell", for: indexPath) as! MyIdeaCollectionViewCell
        
        cell.title.text = ideasList[indexPath.row].title
        cell.desc.text = ideasList[indexPath.row].desc
        cell.image.image = UIImage(data: ideasList[indexPath.row].image!)
        
        //------------ cell for row item at index path-----------------
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
        //-----------------------------

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt source: IndexPath, to destination: IndexPath) {
        let idea = ideasList.remove(at: source.item)
        ideasList.insert(idea, at: destination.item)
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


