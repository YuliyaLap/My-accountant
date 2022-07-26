//
//  MainTableViewCell.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 6/28/22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
