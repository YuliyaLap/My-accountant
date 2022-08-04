//
//  CategoryVC.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 7/1/22.
//

import UIKit

protocol Category {
    func selectedCategory(category: String)
}

class CategoryVC : UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var spend = Bool()
    var delegate: Category?
    
    let expenseCategories: [String] = ["Shopping", "Food", "Payments", "Car", "Beauty", "Other"]
    let incomeCategories: [String] = [ "Salary", "Gift", "Business", "Dividends", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}



extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spend ? expenseCategories.count : incomeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CategoryTableViewCell.self)", for: indexPath) as! CategoryTableViewCell
        
        if spend == true {
            cell.categoryLabel.text = expenseCategories[indexPath.row]
        } else {
            cell.categoryLabel.text = incomeCategories[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        delegate?.selectedCategory(category: selectedCell.categoryLabel.text!)
        navigationController?.popViewController(animated: true)
    }
}

