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
    
    var itemArray = [Item]()
    
    // No need to create IBOutlet for the tableView because it automatically comes from the superclass.
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* No need to set delegate and datasource explicitly here. It comes automatically connected when you inherit from UITableViewController */
        
        // loadItems() // inorder to fetch the item array from "Item.plist".
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
                
                /*
                 All the apps life cycle methods, inside AppDelegate class, would be called at appropriate time by UIApplication class. So, UIApplication class is a sender and AppDelegate class is a receiver. Hence AppDelegate class, which is a reciever, conforms to the UIApplicationDelegate protocol which has all the apps life cycle methods declared. UIApplication class, which is a sender, has a optional delegate property of type UIApplicationDelegate, which would be set as the object of AppDelegate by the Apple itself because apple is only responsible to create an object of UIApplication and AppDelegate class. So when AppDelegate object would be set in the optional delegate property declared in UIApplication, UIApplication can call all the life cycle methods defined in AppDelegate based on the reference of UIApplicationDelegate because under the hood object is of AppDelegate.
                 
                 
                 Inside UIApplication class :
                    unowned(unsafe) open var delegate: UIApplicationDelegate?
                 
                 
                 Apple has to do below thing somewhere, ideally inside a receiver i.e AppDelegate class :
                    (UIApplication object).delegate = (self or AppDelegate object)
                 
                 
                 Now if I want to get the object of AppDelegate class, created by apple, then we can get it through the delegate property declared inside UIApplication class. In order to access delegate property inside UIApplication class, we need object of UIApplication class. Once we get object of UIApplication class then getting object of AppDelegte through delegate property is just a cakewalk. Since delegte property is of type UIApplicationDelegate(even though under the hood object is of type AppDelegate), we need to downcast the reference if we want to access those properties which are defined in AppDelegate and did not come from UIApplicationDelegate.
                 
                 
                 Now if we want to get the object of UIApplication (object of UIApplication class is also called as current app instance) then we can get it like this :
                        UIApplication.shared : it is going to return me the object of UIApplication class, which is a singleton class. So olny one instance of this class got created, which we have now.
                 
                 
                 This is how UIApplication class looks like :
                 open class UIApplication : UIResponder {
                 
                    open class var shared: UIApplication { get }
                    unowned(unsafe) open var delegate: UIApplicationDelegate?
                 
                    ......lot of other properties and methods.
                 }
                 */
                
                let newItem = Item(context: self.context)
                newItem.title = title; newItem.done = false
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
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

