//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 31/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    /* Whenever we are creating realm db, it could throw error only first time because of less resources. But this is second time we are creating because we already did in AppDelegate. So using forced try could be ok here. As many times as we create this, it is gonna point to the same Realm db/file. */
    let realm = try! Realm() // realm is pointing to the persistent realm store.
    
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories() // load categories from sqlite db.
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        categoryCell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet !!!"
        
        return categoryCell
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories() {
        
        // loading from realm store in RAM. It is like Select * from Category
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category : Category) {
        do {
            // writing to realm persistent container.
            try realm.write {
                realm.add(category)
            }
        } catch let err as NSError {
            print("Error saving category \(err)")
        }
    }
    
    //MARK: - Add New Category
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { (action) in
            let name = textField.text!
            
            if !name.isEmpty {
                let newCategory = Category()
                newCategory.name = name
                
                // No need of this, Category object is automatically being controlled here.
               // self.categoryArray.append(newCategory)
                
                self.save(category : newCategory)   // whenever we update categoryArray, we need to add it to sqlite db
                
                self.tableView.reloadData()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            
            let todoListVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                // Even if categoryArray is nil, still didSet will be called.
                todoListVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
}
