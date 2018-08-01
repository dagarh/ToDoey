//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 31/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories() // load categories from sqlite db.
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category: Category = categoryArray[indexPath.row]
        categoryCell.textLabel?.text = category.name
        
        return categoryCell
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data into context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategories() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let err as NSError {
                print("Error saving context \(err)")
            }
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
                let newCategory = Category(context: self.context)
                newCategory.name = name
                
                self.categoryArray.append(newCategory)
                self.saveCategories() // whenever we update categoryArray, we need to add it to sqlite db
                
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
                todoListVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
}
