import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var tableAdvice: [NSManagedObject] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Advices List"
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Advice")
    do {
      tableAdvice = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func addName(_ sender: UIBarButtonItem) {

    let alert = UIAlertController(title: "New Advice",
                                  message: "Add a new advice",
                                  preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

      guard let textField1 = alert.textFields?.first,
        let nameToSave = textField1.text else {
          return
      }
      guard let textField2 = alert.textFields?.first,
        let advisorToSave = textField2.text else {
          return
      }

      self.save(name: nameToSave, advisor: advisorToSave)
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)

    alert.addTextField()

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }

  func save(name: String, advisor: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let entity = NSEntityDescription.entity(forEntityName: "Advice",
                                            in: managedContext)!

    let advice = NSManagedObject(entity: entity,
                                 insertInto: managedContext)

    advice.setValue(name, forKeyPath: "name")
    advice.setValue(advisor, forKeyPath: "advisor")

    do {
      try managedContext.save()
      tableAdvice.append(advice)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return tableAdvice.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let advice = tableAdvice[indexPath.row]
    
    let name = advice.value(forKeyPath: "name")
    let advisor = advice.value(forKeyPath: "advisor")
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    //cell.textLabel?.text = advice.value(forKeyPath: "name") as? String
    //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row) - \(name) - \(advisor)"
    cell.textLabel?.text = "\(section.self): \(name) - \(advisor)"
    
    return cell
  }
  
  
  
  func tableView1(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let advice = tableAdvice[indexPath.row]
    
    let name = advice.value(forKeyPath: "name")
    let advisor = advice.value(forKeyPath: "advisor")
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    //cell.textLabel?.text = advice.value(forKeyPath: "name") as? String
    //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row) - \(name) - \(advisor)"
    cell.textLabel?.text = "\(section.self): \(name) - \(advisor)"
    
    return cell
  }

  
}
