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

    
    let defaults = UserDefaults.standard
    var balance: Float = 0
    
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
    
    @IBAction private func addTransactionButtonDidTap() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "\(ExpenseTransactionScreen.self)")
        navigationController?.pushViewController(nextVC, animated: true)
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
