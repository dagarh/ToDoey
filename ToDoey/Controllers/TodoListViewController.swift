//
//  ViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm() // Pointing to the same realm container which we created earlier.
    
    var todoItems : Results<Item>?  // "Item" is automatically being monitored for Item objects by this array.
    
    // No need to create IBOutlet for the tableView because it automatically comes from the superclass.
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            // even if selectedCategory is set to nil, it would come here. So we need to handle cases accordingly.
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* No need to set delegate and datasource explicitly here. It comes automatically connected when you inherit from UITableViewController */
        
        /* UISearchBar delegate property has been set to the object of TodoListViewController class through UI without creating its outlet here. See the extension below. */
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        /* This will call the method "searchBarTextDidEndEditing". Also remember that after ending the editing in searchBar, keyboard would also go away. */
        if searchBar.text?.count == 0 {
            self.searchBar.endEditing(true)
        }
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let title = textField.text!
            
            if !title.isEmpty {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            /* Inside realm.write if you are making object of any realm data model class then realm knows that and hence would add that automatically to the database. */
                            
                            // whenever we are creating this Item object, it is automatically appended to todoItems Result array.
                            let newItem = Item()
                            newItem.title = title; newItem.done = false
                            newItem.dateCreated = Date()
                            
                            /* After coming to the child we set this child to its Parent. Below line is automatically taking care of newItem.parentCategory = self.selectedCategory. In CoreData, we used to set parent to the child but here we are doing opposite, here we are setting child to the parent. */
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items \(error)")
                    }
                }
                
               // This is automatically being done for us by Realm when you created the object for "Item" above.
              //  self.todoItems.append(newItem)
                
                self.tableView.reloadData()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*  below method gets called by apple when we tap on a cell. And hence to remove that we will call deselectRow(at:animated:) method.
         
         tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none) */
        
        print("Prince")
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
       // tableView.deselectRow(at: indexPath, animated: true)
        
        /* Instead of below code, you could also call reloadData() on tableView to get the desired result but that is not an efficient way. */
        //        let cell = tableView.cellForRow(at: indexPath)
        //        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
        //            cell?.accessoryType = .none
        //        }else {
        //            cell?.accessoryType = .checkmark
        //        }
        
        /*  no need to reload, as and when we set the property, it would be in action.
         tableView.reloadRows(at: [indexPath], with: .automatic) */
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
    }
    
}

//MARK: - UISearchBar Delegate Methods
// extensions are there for extending the functionaliy of Protocol/Class.
extension TodoListViewController : UISearchBarDelegate {
    
    // This method gets called when "Search" button is pressed of keyboard.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count)! > 0 {
            
            todoItems = selectedCategory?.items.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        searchBar.endEditing(true) // same as searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        loadItems()
        searchBar.text = ""
        searchBar.resignFirstResponder() // same as searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // this method will be called by resignFirstResponder() or when we endEditing of seachBar.
        searchBar.showsCancelButton = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // this would only get called when view gets touched, but here in this case we can not touch view on the screen.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
        }else {
            todoItems = selectedCategory?.items.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
    
}

