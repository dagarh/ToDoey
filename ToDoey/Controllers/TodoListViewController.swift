//
//  ViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // No need to create IBOutlet for the tableView because it automatically comes from the superclass.
    
    /* FileManager.default is a singleton object which contains lot of urls, in an organised manner. We just need to get one for document directory. ".userDomainMask" is the user's home directory. In case of "NSUserDefaults", plist got saved in the "Library" section of sandboxing but here in case of "NSCoder", we would save plist in "Document" section of sandboxing of an app. */
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    /* Suppose if you want to store multiple categories of items then you have different-2 plists for each of the categories instead of having one big plist. And retrieve the plist as and when needed. So by this way we prevented ourself from loading the whole big plist so NSCoder is memory efficient way than NSUserDefaults. And also there is another advantage of storing our custom objects. */ 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* No need to set delegate and datasource explicitly here. It comes automatically connected when you inherit from UITableViewController */
        
        print(dataFilePath!)
        
        loadItems() // inorder to fetch the item array from "Item.plist".
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
            let title = (alert.textFields?[0].text)!
            // let item = textField.text!
            if !title.isEmpty {
                self.itemArray.append(Item(title: title, done: false))
    
                self.saveData() // whenever we update itemArray, we need to encode and write that to the "Items.plist"
                
                self.tableView.reloadData()
            }
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
        
        let item: Item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)
        
        /*  below method gets called by apple when we tap on a cell. And hence to remove that we will call deselectRow(at:animated:) method.
         
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none) */
        
        tableView.deselectRow(at: indexPath, animated: true)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData() // whenever we update itemArray, we need to encode and write that to the "Items.plist"
        
        /* Instead of below code, you could also call reloadData() on tableView to get the desired result but that is not an efficient way. */
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = .none
        }else {
            cell?.accessoryType = .checkmark
        }
        
        /*  no need to reload, as and when we set the property, it would be in action.
            tableView.reloadRows(at: [indexPath], with: .automatic) */
    }
    
    
    //MARK: - Model Manipulation Methods
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            /* encoding means converting one datatype to another datatype so that, that another datatype can be written to the plist. So here we converted the datatype from "Array<Item>" to "Data" */
            let data = try encoder.encode(itemArray)
            
            // data is of "Data" datatype which can be written to the plist. So "Data" datatype is familier with the plist.
            try data.write(to: dataFilePath!)
        }catch let err as NSError{
            print("Problem in encoding item array: \(err) ")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                /* decoder is also a way to convert one datatype to another datatype so that we can have it back. Here it is conveting from "Data" datatype to Array<Item> datatype. */
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Problem in decoding item array: \(error)")
            }
        }
    }
    
}

