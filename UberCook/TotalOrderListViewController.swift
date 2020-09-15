//
//  TotalOrderListViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/14.
//

import UIKit


class TotalOrderListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let userDefault = UserDefaults()
    
    var nextMenuRecipeLists = [MenuRecipeList]()
    
    


   
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var adrsTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var remarksTextView: UITextView!
    
    
    @IBOutlet weak var totalMoneyTextView: UILabel!
    
    @IBAction func OnClickcalendarcalendar(_  sender: Any) { //點擊日曆
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextMenuRecipeLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TotalOrderListTableViewCell.self)", for: indexPath) as! TotalOrderListTableViewCell
        
        cell.titleLabel.text = nextMenuRecipeLists[indexPath.row].recipeTitle
    
        
        cell.numberLabel.text = String(self.nextMenuRecipeLists[indexPath.row].number!)

       

        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.text = self.userDefault.value(forKey: "user_name") as? String
        adrsTextField.text = self.userDefault.value(forKey: "user_adrs") as? String
        phoneTextField.text = self.userDefault.value(forKey: "user_phone") as? String
        
//     print(nextMenuRecipeLists)
    }
    
    
    
    
    
}
