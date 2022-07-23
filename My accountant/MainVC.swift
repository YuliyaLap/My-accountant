//
//  MainVC.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 6/28/22.
//

import UIKit


class mainVC: UIViewController {
  
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var lowerView: UIView!
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet private weak var expensesButton: UIButton!
    @IBOutlet private weak var incomesButton: UIButton!
    
    
    let defaults = UserDefaults.standard
    var balance: Float = 0
//    var index: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        
        balance = defaults.float(forKey: "Balance")
        balanceLabel?.text = NSString(format: "%.2f", balance) as String
        
        mainTableView?.layer.cornerRadius = 20
        
        lowerView?.layer.cornerRadius = 10
        lowerView?.layer.masksToBounds = true
        setupExpensesButton()
        setupIncomesButton()
    }
    @IBAction private func addExpensesTransactionButtonDidTap() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "\(ExpenseTransactionScreen.self)")
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @IBAction private func addIncomeButtonDidTap() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyBoard.instantiateViewController(withIdentifier: "\(IncomeTransactionScreen.self)") as? IncomeTransactionScreen else {return}
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    //MARK: - Setup Metod's
    
    private func setupExpensesButton() {
      
        expensesButton.layer.borderWidth = 3.0
        expensesButton.layer.borderColor = UIColor.darkGray.cgColor
        expensesButton.layer.cornerRadius =  10
        expensesButton.clipsToBounds = true
}
    private func setupIncomesButton() {
       incomesButton.layer.borderWidth = 3.0
       incomesButton.layer.borderColor = UIColor.darkGray.cgColor
        incomesButton.layer.cornerRadius = 10
        incomesButton.clipsToBounds = true
}
}

extension mainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "\(MainTableViewCell.self)", for: indexPath)
        return cell ?? .init()
    }
}
