//
//  PostVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/13.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var recipeConTextView: UITextView!
    @IBOutlet weak var recipePointTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeConTextView.layer.borderWidth = 1
        recipeConTextView.layer.borderColor = UIColor.gray.cgColor
        recipeConTextView.layer.cornerRadius = 5
        recipeTitleTextField.layer.borderColor = UIColor.gray.cgColor
        recipeTitleTextField.layer.borderWidth = 1
        recipeTitleTextField.layer.cornerRadius = 5
        recipePointTextField.layer.borderColor = UIColor.gray.cgColor
        recipePointTextField.layer.borderWidth = 1
        recipePointTextField.layer.cornerRadius = 5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
