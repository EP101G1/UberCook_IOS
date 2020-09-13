//
//  CollectionCell.swift
//  UberCook
//
//  Created by 超 on 2020/9/12.
//

import UIKit

class CollectionCell: UITableViewCell {
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionSwitch: UISwitch!
    var index:Int?
    var completionHandler:((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    @IBAction func clickCollection(_ sender: UISwitch) {
        if let index = index {
            completionHandler?(index)
        }
    }
    

}
