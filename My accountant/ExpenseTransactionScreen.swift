//
//  ExpenseTransactionScreen.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 6/28/22.
//

import UIKit

class ExpenseTransactionScreen: UIViewController {
    
   
    @IBOutlet weak var displayLabel: UILabel!
    var stillTyping = false

    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

//
//    @IBOutlet var numberFromKeyboard: [UIButton]! {
//        //чтоб задать свойства кнопке, вызываем наблюдателя свойств didSet и пишем условие, что для кнопки указываем
//        didSet {
//            for button in numberFromKeyboard {
//                button.layer.cornerRadius = 11
//            }
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func loadData(){
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Transaction.amount
                                                                 ), ascending: true )]
        let transactions = try? CoreDataService.mainContext.fetch(request)
    }
    
    
    @IBAction func saveDidTap(){
        let amount = displayLabel.text
        let note = descriptionTextField.text
        let category = categoryTextField.text
        let date = datePicker.date
        
        let transactions = Transaction(context: CoreDataService.mainContext)
        
//
        
        transactions.note = note
        transactions.category = category
        transactions.date = date
        
        CoreDataService.saveContext()
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        
        if stillTyping {
            if displayLabel.text!.count < 10  {
                displayLabel.text = displayLabel.text! + number
            }
        } else {
            displayLabel.text = number
           stillTyping = true
        }
    
    //сделаем так, чтобы количество символов было ограниченно
    // убираем ноль при нажатии на любую клавишу для этого создаем переменную с булевым значением stillTyping
}
    
    @IBAction func resetButton(_ sender: UIButton) {
        displayLabel.text = "0"
        stillTyping = false
    }
    
 
}
