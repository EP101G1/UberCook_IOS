//
//  StartingTableViewCell.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/18.
//

import UIKit

class StartingTableViewCell: UITableViewCell {


    @IBOutlet weak var idLabel: UILabel!
    
    
    @IBOutlet weak var NameLabel: UILabel!
    
    
    @IBOutlet weak var DateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
