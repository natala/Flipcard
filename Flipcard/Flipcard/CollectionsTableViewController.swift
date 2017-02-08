//
//  CollectionsTableViewController.swift
//  Flipcard
//
//  Created by Natalia Zarawska 2 on 07/02/17.
//  Copyright © 2017 Natalia Zarawska 2. All rights reserved.
//

import UIKit
import os.log

class CollectionsTableViewController: UITableViewController {
    
    // MARK: Properties
    var cardDecks = [CardDeck]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load the data
        loadCollections()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDecks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "CollectionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath)
        
        // Configure the cell
        let collection = cardDecks[indexPath.row]
        guard let label = cell.textLabel else {
            fatalError("The cel has not property textLabel")
        }
        label.text = collection.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func
        tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cardDecks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
        
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowCollectionSegue":
            guard let collectionViewController = segue.destination as? CollectionViewController else {
                fatalError("The segue's \(segue.identifier) destination is not a CollectionViewController.")
            }
            guard let sourceCell = sender as? UITableViewCell else {
                fatalError("The source is not a cell")
            }
            guard let indexPath = tableView.indexPath(for: sourceCell) else {
                fatalError("The source cell is not displayed.")
            }
            let collection = cardDecks[indexPath.row]
            collectionViewController.cardDeck = collection
            
        case "AddCollectionSegue":
            os_log("Adding a new collection.", log: OSLog.default, type: .debug)
            
        default:
            os_log("Nothing to do.", log: OSLog.default, type: .debug)
            
        }
    }
    
    
    // MARK: Actions
    @IBAction func unwindToCollectionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CollectionViewController, let newDeck = sourceViewController.cardDeck {
            
            // check if a cell is selected
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    cardDecks[selectedIndexPath.row] = newDeck
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let indexPath = IndexPath(row: cardDecks.count, section: 0)
                cardDecks.append(newDeck)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    // MARK: Private methods
    private func loadCollections() {
        
        // load the card decks from Json
        guard let path = Bundle.main.path(forResource: "collections", ofType: "json"),
            let data = NSData(contentsOfFile: path) as Data?
        else {
            os_log("Unable to find the collection.json", log: OSLog.default, type: .debug)
            return
        }
        
        var decks = [CardDeck]()
        let jsonArray = try? JSONSerialization.jsonObject(with: data as Data, options: [])
        if let array = jsonArray as? [Any] {
            for object in array {
                if let cardDeck = try? CardDeck(object as! [String : Any]) {
                    decks.append(cardDeck!)
                }
            }
        }
        
        cardDecks = decks

    }
    
}
