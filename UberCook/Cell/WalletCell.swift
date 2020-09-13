//
//  WalletCell.swift
//  UberCook
//
//  Created by Kira on 2020/9/13.
//

import UIKit

class WalletCell: UITableViewCell {

    @IBOutlet weak var btMoney: UIButton!
    @IBOutlet weak var lbpoint: UILabel!
    var index : Int?
    var count : ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func linePay(_ sender: UIButton) {
        if let index = index {
            count?(index)
        }
    }
    
}
