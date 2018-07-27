//
//  ViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Milk","Buy Eggs","Destroy Demogorgon"]
    
    // No need to create IBOutlet for the tableView because it automatically comes from the superclass.
    
    let defaults = UserDefaults.standard // This is going to get me a singleton object and it is thread safe.
    /* We should not use UserDefaults for storing collections and large data. So we should not treat UserDefaults as a DB. Because even when we want to retrieve a small value, the whole plist file would get loaded in memory hence only store user preferences and defaults. It can not be used for heavy lifting. So it could be time and memory consuming if you store large amount of data in this. */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* No need to set delegate and datasource explicitly here. It comes automatically connected when you inherit from UITableViewController */
        
        // Retrieving the stored array, array is always of type [Any]?, from UserDefaults singleton object.
        /* defaults.array(forKey: "todoListArray") is not going to crash even if key is not present in plist file, in that case it would return nil. Whenever you are retrieving something from UserDefaults using key, even if key does not exist then app would not crash, it would return default value like 0 or 0.0 in case of int, float and double and nil in case of optionals. */
        // nil as? [String] is always nil.
        if let todoListArray = defaults.array(forKey: Constants.itemArrayKey) as? [String] {
            itemArray = todoListArray
        }
        
        /* defaults.synchronize() --> this method gets called by apple periodically to update the user defaults if any value has been added. You don't have to call this manually. */
    }
    
    /* This would be called after the view has appeared. We are overriding this because at the time of view load, it might so happen that plist file inside the sandbox of app, does not get loaded. */
    override func viewDidAppear(_ animated: Bool) {
        
        // Since this would be called after the tableView() methods, hence it is not prefered to fetch array here.
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            
            // what will happen once the user clicks the Add Item button on our UIAlert
            print((alert.textFields?[0].text)!)
            let item = (alert.textFields?[0].text)!
            // let item = textField.text!
            if !item.isEmpty {
                self.itemArray.append(item)
                self.tableView.reloadData()
            }
            
            /* Set the array in UserDefaults i.e in plist file inside the sandbox. While storing an array inside the UserDefault database, it is intelligent enough to determine the type of Array.  */
            self.defaults.set(self.itemArray, forKey: Constants.itemArrayKey)
            
        }))
        
        present(alert, animated: true, completion: nil)
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

