//
//  ExpenseTransactionScreen.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 6/28/22.
//

import UIKit

protocol TransactionHandler {
    func newTransaction(amount: Float, category: String, note: String, date: Date, newTransaction: Bool)
}


class ExpenseTransactionScreen: UIViewController, Category, UITextFieldDelegate  {

    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    var newTransaction: Bool = true
    var delegate: TransactionHandler?
    
    var amount = Float()
    var category = String()
    var note = String()
    var date = Date()
    
    

        override func viewDidLoad() {
            super.viewDidLoad()

            if newTransaction == false {
                datePicker.date = date
                updateDate()
             
                
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
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            amountTextField.resignFirstResponder()
            categoryTextField.resignFirstResponder()
            descriptionTextField.resignFirstResponder()
            return true
        }
   
        
        @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
            let floatNumber = (amountTextField.text! as NSString).floatValue
            if floatNumber == 0 {
                let alert = UIAlertController(title: "Error", message: "Enter amount", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else {
                delegate?.newTransaction(amount: floatNumber, category: categoryTextField.text!, note: descriptionTextField.text!, date: datePicker.date, newTransaction: newTransaction)
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
        
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "showCategories" {
//                let destinationVC = segue.destination as! CategoryVC
//                destinationVC.delegate = self
//            }
//        }
    }

    extension UITextField{
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

    
//    private func loadData(){
//        let request = Transaction.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Transaction.amount
//                                                                 ), ascending: true )]
//        let transactions = try? CoreDataService.mainContext.fetch(request)
//    }
//    
//    
//    @IBAction func saveDidTap(){
//        let amount = displayLabel.text
//        let note = descriptionTextField.text
//        let category = categoryTextField.text
//        let date = datePicker.date
//        
//        let transactions = Transaction(context: CoreDataService.mainContext)
//        
////
//        
//        transactions.note = note
//        transactions.category = category
//        transactions.date = date
//        
//        CoreDataService.saveContext()
//    }
// 
    

    
  
   


    
