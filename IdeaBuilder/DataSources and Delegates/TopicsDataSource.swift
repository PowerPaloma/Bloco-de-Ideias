//
//  TopicsDataSourceDelegate.swift
//  IdeaBuilder
//
//  Created by Débora Oliveira on 07/01/19.
//  Copyright © 2019 Academy. All rights reserved.
//

import Foundation

import UIKit

class TopicsDataSource: NSObject, UICollectionViewDataSource {
    
    
    //Variables
    var idea = Idea()
    var topics : [Topic] = []
    var movingIndexPath: NSIndexPath?
    var topicSelected = Topic()
    
    //Values for UICollectionViewFlowLayout
    let inset: CGFloat = 8
    let minimunLineSpacing: CGFloat = 0
    let minimunInteritemSpacing: CGFloat = 0
    var cellsPerRow = 2
    var addCellFrame: CGRect!
    
    //Topics Collection View
    let nibText = UINib(nibName: "TopicTextCollectionViewCell", bundle: nil)
    let nibImage = UINib(nibName: "TopicImageCollectionViewCell", bundle: nil)
    let nibDraw = UINib(nibName: "TopicDrawCollectionViewCell", bundle: nil)
    let nibNew = UINib(nibName: "NewTopicCollectionViewCell", bundle: nil)
    
    override init() {
        
    }
    
    func registerNibs(_ collectionView: UICollectionView) -> UICollectionView{
        collectionView.register(nibText, forCellWithReuseIdentifier: "TopicTextCell")
        collectionView.register(nibImage, forCellWithReuseIdentifier: "TopicImageCell")
        collectionView.register(nibDraw, forCellWithReuseIdentifier: "TopicDrawCell")
        collectionView.register(nibNew, forCellWithReuseIdentifier: "NewTopicCell")
        return collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            return collectionView.dequeueReusableCell(withReuseIdentifier: "NewTopicCell", for: indexPath) as! NewTopicCollectionViewCell
        }else{
            //Use diferent types of cells depending on the topic type
            if topics[indexPath.row-1].typeT == TopicsEnum.text.rawValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicTextCell", for: indexPath) as! TopicTextCollectionViewCell
                cell.title.text = topics[indexPath.row-1].titleT
                cell.desc.text = topics[indexPath.row-1].descT
                cell.deleteButton.tag = indexPath.row-1
                //cell.delegate = self
                
//                if isEditing {
//                    cell.startWiggling()
//                } else {
//                    cell.stopWiggling()
//                }
//
//                if (indexPath as NSIndexPath) == movingIndexPath {
//                    cell.alpha = 0.7
//                    cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                } else {
//                    cell.alpha = 1.0
//                    cell.transform = CGAffineTransform.identity
//                }
                return cell
            } else if topics[indexPath.row-1].typeT == TopicsEnum.image.rawValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicImageCell", for: indexPath) as! TopicImageCollectionViewCell
                cell.title.text = topics[indexPath.row-1].titleT
                cell.image.image = UIImage(data: topics[indexPath.row-1].imageT! as Data)
                cell.deleteButton.tag = indexPath.row-1
                //cell.delegate = self
                
//                if isEditing {
//                    cell.startWiggling()
//                } else {
//                    cell.stopWiggling()
//                }
//
//                if (indexPath as NSIndexPath) == movingIndexPath {
//                    cell.alpha = 0.7
//                    cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                } else {
//                    cell.alpha = 1.0
//                    cell.transform = CGAffineTransform.identity
//                }
                return cell
            } else if topics[indexPath.row-1].typeT == TopicsEnum.draw.rawValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicDrawCell", for: indexPath) as! TopicDrawCollectionViewCell
                cell.title.text = topics[indexPath.row-1].titleT
                cell.image.image = UIImage(data: topics[indexPath.row-1].imageT! as Data)
                cell.deleteButton.tag = indexPath.row-1
                //cell.delegate = self
                
//                if isEditing {
//                    cell.startWiggling()
//                } else {
//                    cell.stopWiggling()
//                }
//
//                if (indexPath as NSIndexPath) == movingIndexPath {
//                    cell.alpha = 0.7
//                    cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                } else {
//                    cell.alpha = 1.0
//                    cell.transform = CGAffineTransform.identity
//                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicTextCollectionViewCell
                return cell
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.item != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt source: IndexPath, to destination: IndexPath) {
        
        if destination.item != 0 {
            let topic = topics.remove(at: source.item-1)
            topics.insert(topic, at: destination.item-1)
            
            //            collectionView.moveItem(at: destination, to: source)
            // MUDAR NO CORE DATA A ORDEM DAS IDEIAS
        }
    }
}

// - MARK: CollectionView Delegate FlowLayout
extension TopicsDataSource : UICollectionViewDelegateFlowLayout {
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
        
        let itemWidth = ((UIScreen.main.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow).rounded(.down))
        
        return CGSize(width: itemWidth, height: 160.0)
    }
}
