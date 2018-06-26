//
//  SearchTagsViewController.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import TagListView


class SearchTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TagListViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagListView: TagListView!
    
    lazy var searchBar:UISearchBar = UISearchBar()
    var selectedTags: [Tag] = []
    var inSearchMode = false
    var filteredTags: [Tag] = []
    var delegate: TagDelegate!

    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tagListView.delegate = self
            
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.returnKeyType = UIReturnKeyType.done
        
        tagListView.textFont = UIFont.systemFont(ofSize: 15)
    
        
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
    
    @IBAction func done(_ sender: Any) {
        delegate.tags(tags: selectedTags)
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTags.contains(tags[indexPath.row]){
            var indexSelectedTag = 9
            indexSelectedTag = selectedTags.index(of: tags[indexPath.row])!
            print("indexselectedtag: \(indexSelectedTag)")
            
            selectedTags.remove(at: indexSelectedTag)
            //removing a tag
            tagListView.removeTag(tags[indexPath.row].name!)
        } else {
            selectedTags.append(tags[indexPath.row])
            //adding a tag
            tagListView.addTag(tags[indexPath.row].name!)
        }
        tableView.reloadData()
    }
    
    // Tags
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        removeTag(title)
        sender.removeTagView(tagView)
    }
    
    func removeTag(_ title: String){
        for (index,tag) in selectedTags.enumerated(){
            if tag.name == title{
                selectedTags.remove(at: index)
                tableView.reloadData()
            }
        }
    }
    
}
