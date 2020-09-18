//
//  startingOrderInfoTableViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/18.
//

import UIKit

class startingOrderInfoTableViewController: UITableViewController {
    
    var orderList:Order?
    
    @IBOutlet weak var OrderDateTextField: UITextField!
    
    @IBOutlet weak var OrderNameTextField: UITextField!
    
    @IBOutlet weak var adrsTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var remarkTextView: UITextView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var EvaluationButton: UIButton!
    
    @IBOutlet weak var userNoButton: UIButton!
    
    
    @IBOutlet weak var chefNoButton: UIButton!
    
    @IBOutlet weak var cancleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let controller = parent as? StartingDetailViewController
//        print("orderList", controller, controller?.orderList)
        orderList = controller?.orderList
        
        
        let dateTostr = orderList?.order_date
        OrderDateTextField.text = dateConvertString(date: dateTostr!)

        OrderNameTextField.text = orderList?.user_name
        phoneTextField.text = orderList?.phone
        remarkTextView.text = orderList?.remark
        adrsTextField.text = orderList?.address
    }
    
    

    
    
    
    
    
    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String { //date型態轉string
        
        let dateFormatter = DateFormatter() //設定時間格式

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
   

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
