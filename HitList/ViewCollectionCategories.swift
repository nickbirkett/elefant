//
//  ViewCollectionCategories.swift
//  Elefant03
//
//  Created by Vanesa Gomez gonzalez on 7/26/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation




import UIKit
import CoreData

class ViewCollectionCategories: UICollectionViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var tableCategories: [NSManagedObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Categories List"
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Categories")
    do {
      tableCategories = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
  @IBAction func addName(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "New Category",
                                  message: "Add a new category",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
      
      guard let textField1 = alert.textFields?.first,
        let nameToSave = textField1.text else {
          return
      }
      
      self.save(name: nameToSave)
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  func save(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Categories",
                                            in: managedContext)!
    
    let category = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
    
    category.setValue(name, forKeyPath: "name")
    
    do {
      try managedContext.save()
      tableCategories.append(category)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewCollectionCategories: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return tableCategories.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let category = tableCategories[indexPath.row]
    
    let name = category.value(forKeyPath: "name")
    var uuidString:String = name as! String
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "\(String(describing: uuidString))"
    
    return cell
  }
  
  
}
