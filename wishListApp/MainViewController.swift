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
        
       // generateTestData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objects = controller.fetchedObjects, objects.count > 0 {
            
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsController {
                if let item = sender as? Item    {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segmentedControl.selectedSegmentIndex == 0  {
            
            fetchRequest.sortDescriptors = [dateSort]

        } else if segmentedControl.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segmentedControl.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        
         let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
     
        do{
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
        
        
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
    
    
    func generateTestData(){
        
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 2_000
        item.details = "Definitely need to upgrade to 32 Gigs of RAM, 1TB flash storage with a QuadCore 4.0Ghz Processer and a discrete GPU with the full Adobe suite"
        
        let item2 = Item(context: context)
        item2.title = "Bose Noise Cancelling Headphones"
        item2.price = 350
        item2.details = "Studio quality and cancels out noise FTW"
        
        let item3 = Item(context: context)
        item3.title = "Bentley Continental GT"
        item3.price = 200_000
        item3.details = "Matte Black, Gold Rims, you know I'm stunting."
        
        ad.saveContext()
    }
    
    
    
    

    
    
    
    
    
    
    
    
    

    
    
    
}

