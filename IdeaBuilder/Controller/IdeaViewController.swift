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

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var ideaImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    @IBOutlet var viewP: UIView!
//    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    
//    //Variables
    var idea = Idea()
    var topicsCollectionViewDataSource = TopicsDataSource()
    var topicsList : [Topic] = []
    var longPressGR: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    var topicSelected = Topic()
//    let overlayTransitioningDelegate = OverlayTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCoreDataData()
        
        self.mainTableView.dataSource = self
        
        //Set Idea data to view
        self.ideaImageView.image = UIImage(data: self.idea.image! as Data)
        self.titleLabel.text = self.idea.title
        self.descriptionLabel.text = self.idea.desc
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func getCoreDataData() {
        //Core Data
        self.topicsList = idea.topics?.allObjects as! [Topic]
//  mainTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Perform segue
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
    
//    private func prepareOverlay(viewController: OverlayViewController) {
//        viewController.transitioningDelegate = overlayTransitioningDelegate
//        viewController.modalPresentationStyle = .custom
//        viewController.idea = self.idea
//
//    }
}

extension IdeaViewController : UICollectionViewDelegate {

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
    

}

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if (scrollView.contentOffset.y > 20){
//            let overlayViewController = storyboard?.instantiateViewController(withIdentifier: "overlayViewController") as! UIViewController
//            prepareOverlay(viewController: overlayViewController as! OverlayViewController)
//
//
//            present(overlayViewController, animated: true, completion: {
//               scrollView.contentOffset.y = 0
//            })
//        }
//
//
//    }

extension IdeaViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTopicsCollection") as! UITableViewCell
        
        if indexPath.row == 0 {
            var topicsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 600.0), collectionViewLayout: UICollectionViewFlowLayout())
            topicsCollectionView.backgroundColor = UIColor.red
            
            let topicsCollectionViewDataSource = TopicsDataSource()
            topicsCollectionViewDataSource.idea = self.idea
            topicsCollectionViewDataSource.topics = self.topicsList
            topicsCollectionView = topicsCollectionViewDataSource.registerNibs(topicsCollectionView)
        
            topicsCollectionView.dataSource = topicsCollectionViewDataSource
            topicsCollectionView.delegate = self
            
            cell.addSubview(topicsCollectionView)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            var collectionHeight = topicsList.count*100
            return CGFloat(collectionHeight)
        }
        return 0.0
    }
    
    
}
    





