//
//  TotalOrderListViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/14.
//

import UIKit

class TotalOrderListViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var dateTextView: UITextView!
    
    @IBOutlet weak var nameTextView: UITextView!
    
    @IBOutlet weak var adrsTextView: UITextView!
    
    
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var remarksTextView: UITextView!
    
    
    @IBOutlet weak var totalMoneyTextView: UILabel!
    
    @IBAction func OnClickcalendarcalendar(_  sender: Any) { //點擊日曆
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TotalOrderListTableViewCell.self)", for: indexPath)

        

        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
