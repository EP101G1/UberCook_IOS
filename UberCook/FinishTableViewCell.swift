//
//  FinishTableViewCell.swift
//  
//
//  Created by Hsuan on 2020/9/21.
//

import UIKit

class FinishTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var IdLabel: UILabel!
    
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
