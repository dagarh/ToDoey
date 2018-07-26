//
//  ViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Milk","Buy Eggs","Destroy Demogorgon"]
    
    // No need to create IBOutlet for the tableView because it automatically comes from the superclass.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* No need to set delegate and datasource explicitly here. It comes automatically connected when you inherit from UITableViewController */
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(itemArray.count)
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* You can use any of the tableView(local/global variable) here, both refers to the same object.
         
         Could have used this also: let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell") */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        /*  below method gets called by apple when we tap on a cell. And hence to remove that we will call deselectRow(at:animated:) method.
         
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none) */
        
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = .none
        }else {
            cell?.accessoryType = .checkmark
        }
        
        /*  no need to reload, as and when we set the property, it would be in action.
            tableView.reloadRows(at: [indexPath], with: .automatic) */
    }
    
    
    
    
    
}
