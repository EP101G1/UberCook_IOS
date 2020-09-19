//
//  MessageCell.swift
//  UberCook
//
//  Created by 超 on 2020/9/18.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageUserImage: UIImageView!
    @IBOutlet weak var messageUserNameLabel: UILabel!
    @IBOutlet weak var messageUserConLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
