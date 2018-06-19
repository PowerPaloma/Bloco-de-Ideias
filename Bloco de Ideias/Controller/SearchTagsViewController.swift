//
//  SearchTagsViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class SearchTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar()
    var selectedTags: [Tag] = []
    var inSearchMode = false
    var filteredTags: [Tag] = []
    
    var tags: [Tag] {
        let entity = DataManager.getEntity(entity: "Tag")
        let query = DataManager.getAll(entity: entity)
        
        if (query.success){
            if(query.objects.count > 0){
                return query.objects as! [Tag]
            }
        }else{
            NSLog("Error on reading processes from Database...")
        }
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTags()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func loadTags(){
        let t1:Tag = Tag()
        t1.name = "Tecnologia"
        
        let t2:Tag = Tag()
        t2.name = "Aplicativo"

        let t3:Tag = Tag()
        t3.name = "Inovação"
        
        t1.save()
        t2.save()
        t3.save()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredTags.count
        }
        return tags.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        if inSearchMode {
            cell.accessoryType = .none
            cell.textLabel?.text = filteredTags[indexPath.row].name
            if selectedTags.contains(filteredTags[indexPath.row]) {
                cell.accessoryType = .checkmark
            }
        } else {
            cell.accessoryType = .none
            cell.textLabel?.text = tags[indexPath.row].name
            if selectedTags.contains(tags[indexPath.row]) {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            filteredTags = tags.filter({
                if (($0.name?.lowercased().range(of: searchBar.text!.lowercased())) != nil){
                  return true
                }
                return false
            })
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTags.contains(tags[indexPath.row]){
            var indexSelectedTag = 9
            indexSelectedTag = selectedTags.index(of: tags[indexPath.row])!
            print("indexselectedtag: \(indexSelectedTag)")
            selectedTags.remove(at: indexSelectedTag)
        } else {
          selectedTags.append(tags[indexPath.row])
        }
        tableView.reloadData()
    }
}
