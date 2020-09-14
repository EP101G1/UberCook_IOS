//
//  TotalOrderListTableViewCell.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/14.
//

import UIKit

class TotalOrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    
    @IBOutlet weak var cashLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
