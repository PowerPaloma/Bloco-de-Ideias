//
//  AppDelegate.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 07/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var processList: [Process] = []
        var tagList: [Tag] = []
        var suggestionList: [Suggestion] = []
        var suggestionOrderList: [SuggestionOrder] = []
        var suggestionStatusList: [SuggestionStatus] = []
        
        //-------Process
        let p1:Process = Process()
        p1.name = "Free"
        processList.append(p1)
        
        let p2:Process = Process()
        p2.name = "CBL"
        processList.append(p2)
        
        let p3:Process = Process()
        p3.name = "Canvas"
        processList.append(p3)

        let p4:Process = Process()
        p4.name = "Design Thinking"
        processList.append(p4)
        //--------------------------------
        
        // ------ tags
        let t1:Tag = Tag()
        t1.name = "Game"
        tagList.append(t1)
        
        let t2:Tag = Tag()
        t2.name = "App"
        tagList.append(t2)
        
        let t3:Tag = Tag()
        t3.name = "Product"
        tagList.append(t3)
        
        let t4:Tag = Tag()
        t4.name = "Party"
        tagList.append(t4)
        
        let t5:Tag = Tag()
        t5.name = "Business"
        tagList.append(t5)
        
        let t6:Tag = Tag()
        t6.name = "Art"
        tagList.append(t6)
        
        let t7:Tag = Tag()
        t7.name = "Music"
        tagList.append(t7)
        
        let t8:Tag = Tag()
        t8.name = "Story"
        tagList.append(t8)
        
        let t9:Tag = Tag()
        t9.name = "Fashion"
        tagList.append(t9)
        
        let t10:Tag = Tag()
        t10.name = "Research"
        tagList.append(t10)
        
        let t11:Tag = Tag()
        t11.name = "Software"
        tagList.append(t11)
        
        let t12:Tag = Tag()
        t12.name = "Architecture"
        tagList.append(t12)
        
        let t13:Tag = Tag()
        t13.name = "Technology"
        tagList.append(t13)
        
        let t14:Tag = Tag()
        t14.name = "Theater"
        tagList.append(t14)
        
        let t15:Tag = Tag()
        t15.name = "Dance"
        tagList.append(t15)
        
        let t16:Tag = Tag()
        t16.name = "Site"
        tagList.append(t16)
        
        let t17:Tag = Tag()
        t17.name = "Design"
        tagList.append(t17)
        
        let t18:Tag = Tag()
        t18.name = "User Interface"
        tagList.append(t18)
        
        let t19:Tag = Tag()
        t19.name = "Audio-visual"
        tagList.append(t19)
        
        //-------------------------
        
        
        //-----------suggestions Order in process free
        let sO1:SuggestionOrder = SuggestionOrder()
        sO1.order = 0
        sO1.process = p1
        suggestionOrderList.append(sO1)
        
        //-------------------
        
        
        //--------Suggestions of process free
        let s1:Suggestion = Suggestion()
        s1.titleS = "Who is my audience?"
        s1.descS = "Imagine you had the single perfect audience member in front of you – who would that be?"
        s1.topicTitle = "Audience"
        s1.isText = true
        s1.addToProcesses(p1)
        //let s1Tags: Array<Tag> = [t1, t2, t3, t4, t6, t7, t8, t9, t10, t11, t12, t13, t17, t18, t19]
//        s1.addToTags(t1)
//        s1.addToTags(t2)
//        s1.addToTags(t3)
//        s1.addToTags(t4)
//        s1.addToTags(t6)
//        s1.addToTags(t7)
//        s1.addToTags(t8)
//        s1.addToTags(t9)
//        s1.addToTags(t10)
//        s1.addToTags(t11)
//        s1.addToTags(t12)
//        s1.addToTags(t13)
//        s1.addToTags(t17)
//        s1.addToTags(t18)
//        s1.addToTags(t19)
        suggestionList.append(s1)
        
        let s2:Suggestion = Suggestion()
        s2.titleS = "What is the problem my idea is solving?"
        s2.descS = ""
        s2.topicTitle = "Problem"
        s2.isText = true
        s2.addToProcesses(p1)
        //let s2Tags:Array<Tag> = [t1, t2, t3, t4, t6, t7, t8, t9, t10, t11, t12, t13, t17, t18, t19]
        //self.addTagsInSuggestion(tags: s2Tags, s: s2)
//        s1.addToTags(t2)
//        s1.addToTags(t3)
//        s1.addToTags(t5)
//        s1.addToTags(t10)
//        s1.addToTags(t11)
//        s1.addToTags(t13)
//        s1.addToTags(t16)
//        s1.addToTags(t17)
        suggestionList.append(s2)
        
        let s3:Suggestion = Suggestion()
        s3.titleS = "What are the impacts of my idea?"
        s3.descS = "What will the world look like if I’m able to change it?"
        s3.topicTitle = "Impacts"
        s3.isText = true
        s3.addToProcesses(p1)
//        let s3Tags: Array<Tag> = [t2, t3, t5, t6, t10, t11, t12, t13, t14, t16, t17, t18, t19]
//        self.addTagsInSuggestion(tags: s3Tags, s: s3)
//        s1.addToTags(t2)
//        s1.addToTags(t3)
//        s1.addToTags(t5)
//        s1.addToTags(t6)
//        s1.addToTags(t10)
//        s1.addToTags(t11)
//        s1.addToTags(t12)
//        s1.addToTags(t13)
//        s1.addToTags(t14)
//        s1.addToTags(t16)
//        s1.addToTags(t17)
//        s1.addToTags(t18)
//        s1.addToTags(t19)
        
        suggestionList.append(s3)
        
        let s4:Suggestion = Suggestion()
        s4.titleS = "What are my motivations?"
        s4.descS = "Why this is important to me?"
        s4.topicTitle = "Motivations"
        s4.isText = true
        s4.addToProcesses(p1)
//        let s4Tags: Array<Tag> = [t2, t3, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19]
//        self.addTagsInSuggestion(tags: s4Tags, s: s4)
//        s1.addToTags(t2)
//        s1.addToTags(t3)
//        s1.addToTags(t5)
//        s1.addToTags(t6)
//        s1.addToTags(t10)
//        s1.addToTags(t11)
//        s1.addToTags(t12)
//        s1.addToTags(t13)
//        s1.addToTags(t14)
//        s1.addToTags(t16)
//        s1.addToTags(t17)
//        s1.addToTags(t18)
//        s1.addToTags(t19)
        suggestionList.append(s4)
        //--------------------------------
        
    
    
        
        //---------Saving tags, processes and suggestions
        self.saving(recordsToSave:tagList, entityName: "Tag")
        self.saving(recordsToSave: processList, entityName: "Process")
        self.saving(recordsToSave: suggestionOrderList, entityName: "SuggestionOrder")
        self.saving(recordsToSave: suggestionList, entityName: "Suggestion")
        //--------------------------------------------------

        return true
    }
    
    // try this later
//    func addTagsInSuggestion(tags:[Tag], s: Suggestion){
//        for tag in tags{
//            s.addToTags(tag)
//        }
//
//    }
    
    
    func saving(recordsToSave: [Any] ,entityName: String){
        print("testing \(entityName)")
        let entity = DataManager.getEntity(entity: entityName)
        let entityRecords = DataManager.getAll(entity: entity)
        print(entityRecords.objects.count)
        
        if (entityRecords.success){
            if(entityRecords.objects.count == 0){
                NSLog("Saving \(entityName)...")
                if recordsToSave is [Process]{
                    for rec in recordsToSave as! [Process]{
                        print("PROCESS")
                        rec.save()
                    }
                }else if recordsToSave is [Tag]{
                    for rec in recordsToSave as! [Tag]{
                        print("TAG")
                        rec.save()
                    }
                }else if recordsToSave is [Suggestion]{
                    for rec in recordsToSave as! [Suggestion]{
                        print("SUGGESTION")
                        rec.save()
                    }
                }else if recordsToSave is [SuggestionOrder]{
                    for rec in recordsToSave as! [SuggestionOrder]{
                        print("SUGGESTION ORDER")
                        rec.save()
                    }
                }
                
                
            }
        }else{
            NSLog("Error on saving \(entityName)...")
        }
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IdeaBuilder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

