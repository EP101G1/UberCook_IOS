//
//  WaittingDetailTableViewCell.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/18.
//

import UIKit

class WaittingDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NameLabel: UILabel!
    
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
