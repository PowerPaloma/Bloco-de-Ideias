//
//  VisualizarIdeiaViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 07/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class IdeaViewController: UIViewController {
    
    //Outlets from View
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var ideaImage: UIImageView!
    @IBOutlet var titleIdea: UILabel!
    @IBOutlet weak var descrip: UILabel!
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
        let nibNew = UINib(nibName: "NewTopicCollectionViewCell", bundle: nil)
        self.collectionView.register(nibNew, forCellWithReuseIdentifier: "NewTopicCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //Set Idea data to view
        self.ideaImage.image = UIImage(data: self.idea.image! as Data)
        self.titleIdea.text = self.idea.title
        self.descrip.text = self.idea.desc
        
        getCoreDataData()
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreDataData()

    }
    
    func getCoreDataData() {
        //Core Data
//
        self.topicsList = idea.topics?.allObjects as! [Topic]
        collectionView.reloadData()
        self.ideaImage.image = UIImage(data: self.idea.image! as Data)
        self.titleIdea.text = self.idea.title
        self.descrip.text = self.idea.desc
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
    
    
    //Improve Idea
    @IBAction func improveIdea(_ sender: UIButton) {
        let context = DataManager.getContext()
        let tagsNames = self.idea.tags!.map{ ($0 as! Tag).name! }
        
        //Core Data - getting suggestions who has the tag of this idea
        do {
            let fetchRequest : NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
            fetchRequest.predicate = NSPredicate(format:"(ANY tags.name in %@) AND (ANY processes.name in %@)"
                ,tagsNames
                ,[self.idea.process!.name!]
            )
            
            let fetchedResults = try context.fetch(fetchRequest)
            
            print(self.idea.suggestionStatus!.count, fetchedResults.count)
            
            if self.idea.suggestionStatus!.count < fetchedResults.count {
                performSegue(withIdentifier: "improve", sender: nil)
            } else {
                let alertSheet: UIAlertController = UIAlertController(title: "Go Head!",
                                                                      message: "Congratulations!\n We think you're ready put your idea into practice!",
                                                                      preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertSheet.addAction(okAction)
                
                self.present(alertSheet, animated: true, completion: nil)
            }
        }catch {
            NSLog("Error on loading suggestions...")
        }
    }
    
    
    @IBAction func compose(_ sender: Any) {
        performSegue(withIdentifier: "editIdea", sender: nil)
    }
    
    
    private func prepareOverlay(viewController: OverlayViewController) {
        viewController.transitioningDelegate = overlayTransitioningDelegate
        viewController.modalPresentationStyle = .custom
        viewController.idea = self.idea

    }

    
}

extension IdeaViewController : UICollectionViewDelegate, UICollectionViewDataSource {
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y > 20){
            let overlayViewController = storyboard?.instantiateViewController(withIdentifier: "overlayViewController") as! UIViewController
            prepareOverlay(viewController: overlayViewController as! OverlayViewController)
            
        
            present(overlayViewController, animated: true, completion: {
               scrollView.contentOffset.y = 0
            })
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



