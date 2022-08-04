//
//  ExpenseTransactionScreen.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 6/28/22.
//

import UIKit
import CoreData

protocol TransactionHandler {
    func newTransaction(spend: Bool, amount: Float, category: String, note: String, date: Date, newTransaction: Bool)
}

class TransactionScreen: UIViewController, Category, UITextFieldDelegate  {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    var newTransaction: Bool = true
    var delegate: TransactionHandler?
    var moneySpend: Bool = true
    
    var amount = Float()
    var category = String()
    var note = String()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newTransaction == false {
            datePicker.date = date
            updateDate()
            
            if moneySpend == true {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
            
            DispatchQueue.main.async {
                self.amountTextField.text = "\(self.amount)"
                self.categoryTextField.text = self.category
                self.descriptionTextField.text = self.note
            }
        }
        
        datePicker.isHidden = true
        updateDate()
        
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateTextField.addGestureRecognizer(tapGesture)
        
        amountTextField.delegate = self
        categoryTextField.delegate = self
        descriptionTextField.delegate = self
        
        amountTextField.addDoneButtonToKeyboard(myAction:  #selector(self.amountTextField.resignFirstResponder))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func segmentedSwitcher(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            moneySpend = true
        } else {
            moneySpend = false
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let floatNumber = (amountTextField.text! as NSString).floatValue
        if floatNumber == 0 {
            let alert = UIAlertController(title: "Error", message: "Enter amount", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            delegate?.newTransaction(spend: moneySpend, amount: floatNumber, category: categoryTextField.text!, note: descriptionTextField.text!, date: datePicker.date, newTransaction: newTransaction)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
    }
    
    @objc func showDatePicker() {
        datePicker.isHidden = false
        amountTextField.endEditing(true)
        categoryTextField.endEditing(true)
        descriptionTextField.endEditing(true)
        dateTextField.endEditing(true)
    }
    
    func selectedCategory(category: String) {
        categoryTextField.text = category
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories" {
            let destinationVC = segue.destination as! CategoryVC
            destinationVC.spend = moneySpend
            destinationVC.delegate = self
        }
    }
}


extension UITextField {
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}









