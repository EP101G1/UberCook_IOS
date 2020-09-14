//
//  MenuCollectionViewCell.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/13.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    var compeltionHandler:(([Int],Int,[Bool]) -> Void)?
    var didselect:[Bool]?
    var addnumber:[Int]?
    var index:Int?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var cashLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    
    @IBOutlet weak var addLessStepper: UIStepper!
    
    
    @IBAction func onClickaddLess(_ sender: UIStepper) {
        print("\(addnumber![index!])")
        print(sender.value)
        
        if var addnumber = addnumber,
           let didselect = didselect,
           let index = index{
            if(didselect[index]){
                addnumber[index] = Int(sender.value)
            }
                compeltionHandler?(addnumber,index,didselect)
            
        }
    }
    
    
}
