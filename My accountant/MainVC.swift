//
//  MainVC.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 6/28/22.
//

import UIKit
import CoreData

class MainVC: UIViewController, TransactionHandler  {
  

    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var lowerView: UIView!
    @IBOutlet var balanceLabel: UILabel!

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultController: NSFetchedResultsController<Transaction>!
    
    
    let defaults = UserDefaults.standard
    var balance: Float = 0
    var index: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        
        balance = defaults.float(forKey: "Balance")
        balanceLabel?.text = NSString(format: "%.2f", balance) as String
        
        mainTableView?.layer.cornerRadius = 20
        
        lowerView?.layer.cornerRadius = 10
        lowerView?.layer.masksToBounds = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @IBAction private func addTransactionButtonDidTap() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "\(TransactionScreen.self)")
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Saving error: \(error)")
        }
        
        mainTableView.reloadData()
    }
    
    
    func loadData() {
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(Transaction.isDate), cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Load data error: \(error)")
        }
        
        mainTableView.reloadData()
    }
    

    
    func balanceOperation(spend: Bool, amount: Float) {
        if spend == true {
            balance -= amount
            defaults.set(balance, forKey: "Balance")
            
        } else {
            balance += amount
            defaults.set(balance, forKey: "Balance")
        }
    }

    func configureCell(_ cell: MainTableViewCell, at indexPath: IndexPath) {
        guard let transaction = self.fetchedResultController?.object(at: indexPath) else {
            fatalError("Can't configure cell")
        }
        
        cell.categoryLabel.text = transaction.category
        cell.descriptionLabel.text = transaction.description ?? ""
        
        if transaction.expense == true {
            cell.sumLabel.textColor = UIColor.red
            cell.sumLabel.text = "-\(transaction.amount)"
        } else {
            cell.sumLabel.textColor = UIColor.green
            cell.sumLabel.text = "+\(transaction.amount)"
        }
        
        cell.layer.cornerRadius = 20
    }
    
    func balanceCalculation(transaction: Transaction) {
        if transaction.expense == true {
            self.balance += transaction.amount
        } else {
            self.balance -= transaction.amount
        }
    }
    
    func newTransaction(spend: Bool, amount: Float, category: String, note: String, date: Date, newTransaction: Bool) {
        if newTransaction == true {
            let transaction = Transaction(context: context)
            
            transaction.category = category
            transaction.note = note
            transaction.date = date
            transaction.amount = amount
            transaction.expense = spend
            
            
        } else {
            guard let transaction = fetchedResultController?.object(at: index) else { fatalError("No object with this IndexPath") }
            transaction.amount = amount
            transaction.category = category
            transaction.note = note
            transaction.expense = spend
            transaction.date = date
            
            balanceOperation(spend: spend, amount: amount)
            
            mainTableView.reloadData()
        }
    }
    
    
}



extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        
    guard let sections = self.fetchedResultController.sections else  {
        fatalError("No sections in fetchedResultController")
    }
    let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "\(MainTableViewCell.self)", for: indexPath)
        configureCell(cell as! MainTableViewCell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultController?.sections?[section] else {
            return nil
        }

        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let transcation = self.fetchedResultController?.object(at: indexPath) else { fatalError("Error") }
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.balanceCalculation(transaction: transcation)
            self.defaults.set(self.balance, forKey: "Balance")
            self.balanceLabel.text = NSString(format: "%.2f", self.balance) as String
            self.context.delete(transcation)
            self.saveData()
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.index = self.fetchedResultController.indexPath(forObject: transcation)
            self.balanceCalculation(transaction: transcation)
            self.performSegue(withIdentifier: "newTransaction", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
}


extension Transaction {
    
    @objc var isDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            
            return dateFormatter.string(from: date!)
        }
    }
}


extension MainVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                print("Added:\(indexPath)")
               mainTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                print("Delete:\(indexPath)")
                mainTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                mainTableView.reloadRows(at: [indexPath], with: .fade)
            }
                break
            case .move:
                if let indexPath = indexPath {
                    mainTableView.deleteRows(at: [indexPath], with: .fade)
                }
                if let newIndexPath = newIndexPath {
                    print("Move:\(newIndexPath)")
                    mainTableView.insertRows(at: [newIndexPath], with: .fade)
                }
                break
            @unknown default:
                break
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            switch type {
            case .insert:
                mainTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
                break
            case .delete:
                mainTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
                break
            default:
                break
            }
        }
    }

