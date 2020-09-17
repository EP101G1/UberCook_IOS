//
//  WaittingTableViewCell.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/17.
//

import UIKit

class WaittingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var NameLebel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
