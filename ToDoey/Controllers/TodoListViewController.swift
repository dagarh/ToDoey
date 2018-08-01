//
//  ViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()  // Item is automatically monitored by persistent container.
    
    // No need to create IBOutlet for the tableView because it automatically comes from the superclass.
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* No need to set delegate and datasource explicitly here. It comes automatically connected when you inherit from UITableViewController */
        
        /* UISearchBar delegate property has been set to the object of TodoListViewController class through UI without creating its outlet here. See the extension below. */
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        DispatchQueue.global(qos:.userInteractive).async {
            print("First: \(Thread.isMainThread)  \(Thread.current)")
            self.doSomeTimeConsumingTask() // takes 5 seconds to respond
            DispatchQueue.main.async {
                print("third: \(Thread.isMainThread)  \(Thread.current)")
                // self.tableView.reloadData()
            }
        }
    }
    
    func doSomeTimeConsumingTask() {
        print("Second: \(Thread.isMainThread)  \(Thread.current)")
        sleep(3)
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
                
                let newItem = Item(context: self.context)
                newItem.title = title; newItem.done = false
                
                /* After coming to the child we set the parent, so with the below line, new item has automatically been added to the selectedCategory. So if you try to print like this : print((self.selectedCategory?.items)!), it will show. */
                newItem.parentCategory = self.selectedCategory
                
                
                self.itemArray.append(newItem)
                self.saveItem() // whenever we update itemArray, we need to add it to sqlite db
                
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
        print(itemArray[indexPath.row].title!)
        
        /*  below method gets called by apple when we tap on a cell. And hence to remove that we will call deselectRow(at:animated:) method.
         
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none) */
        
        tableView.deselectRow(at: indexPath, animated: true)

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem() // whenever we update itemArray, we need to add it to the sqlite db.
        
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
    func saveItem () {
        if context.hasChanges {
            do {
                // It is saving all the changes to persistent container from RAM.
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadItems(withR request: NSFetchRequest<Item> = Item.fetchRequest(), withP predicate: NSPredicate? = nil) {
        do {
            print("Sixth: \(Thread.isMainThread)  \(Thread.current)")
            
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
            
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            }else{
                request.predicate = categoryPredicate
            }
            
            // here we are fetching the data into context from the persistent container by sending the request.
            itemArray = try context.fetch(request)
            self.tableView.reloadData()
            
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

//MARK: - UISearchBar Delegate Methods
// extensions are there for extending the functionaliy of Protocol/Class.
extension TodoListViewController : UISearchBarDelegate {
    
    // This method gets called when "Search" button is pressed of keyboard.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count)! > 0 {
            loadItems(withP: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
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
            print("Fourth: \(Thread.isMainThread)  \(Thread.current)")
            
            self.loadItems()
            
            /* It is not ok to update the UI things using background thread. If there are 2 completely independent tasks then you have to do those tasks using diff-2 threads like this. */
            /* Run on the main thread so that searchbar loses focus and keyboard is dimissed, even if background threads are running. Otherwise, app might assign this code to another thread because this code is independent to the loadItems() things. */
            DispatchQueue.main.async {
                print("Fifth: \(Thread.isMainThread)  \(Thread.current)")
                // searchBar.endEditing(true)
            }
            
        }else {
            print("Seventh: \(Thread.isMainThread)  \(Thread.current)")
            loadItems(withP: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
        }
    }
    
}

