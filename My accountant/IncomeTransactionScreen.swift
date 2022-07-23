//
//  File.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 7/7/22.
//

import UIKit

class IncomeTransactionScreen: UIViewController {
    
   
    @IBOutlet weak var displayLabel: UILabel!
    var stillTyping = false

    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
}
