//
//  MainViewController.swift
//  wishListApp
//
//  Created by Szi Gabor on 4/4/17.
//  Copyright © 2017 Szi. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath) as! ItemCell
        configureCell(cell: cell, indexPath: IndexPath as NSIndexPath)
        return cell
                
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item:item)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = controller.sections {
         
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects

        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
             return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
         self.controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
     
        do{
            
            try self.controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController <NSFetchRequestResult>){
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch(type) {
            
        case.insert:
            
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
                
                //insert a new table cell
                
            }
            
        case.delete:
            
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                //delete a table cell
            }
            
        case.update:
            
            if let indexPath = indexPath {
                
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                //update the cell data
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            
        case.move:
            
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                
                //Move cell positions around
            }
            
            
        }
        
        
    }
    
    
    
    

    
    
    
    
    
    
    
    
    

    
    
    
}

