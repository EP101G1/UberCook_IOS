//
//  WaittingTableViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/17.
//

import UIKit

class WaittingTableViewController: UITableViewController {
    
    let userDefault = UserDefaults()
    var orderList = [Order]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getOrder(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getOrder"
        requestParam["chef_no"] = self.userDefault.value(forKey: "chef_no") ?? 0
        requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
        requestParam["flag"] = 0
    
        executeTask(URL(string: common_url + "Order_Servlet")!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter() //設定時間格式
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
         
            try! decoder.decode([Order].self, from: data!)
            
            if error == nil {
                if data != nil {
                print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([Order].self, from: data!){
                        self.orderList = result
//                        print("\(self.orderList[0].deal_date) + !!!!!!!!!")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WaittingTableViewCell.self)", for: indexPath) as! WaittingTableViewCell
        
        cell.idLabel.text = String(orderList[indexPath.row].order_no!)
        
        let ordercheffNo = orderList[indexPath.row].user_no
        let myuserNo = userDefault.value(forKey: "user_no") as! String
        if ordercheffNo == myuserNo {
            cell.NameLebel.text = "待審核"
        }else{
            cell.NameLebel.text = orderList[indexPath.row].user_name
        }
        
        
       let dateTostr = orderList[indexPath.row].deal_date
        cell.dateLabel.text = dateConvertString(date: dateTostr)

        

        return cell
    }
    
    

    
    
    
    @IBSegueAction func TakeOrderToDetail(_ coder: NSCoder) -> WaittingDetailViewController? {
        let controller = WaittingDetailViewController(coder: coder)
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.orderList = orderList[row]
        }
        return controller
    }
    
    
    
    
    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String { //date型態轉string
        
        let dateFormatter = DateFormatter() //設定時間格式

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
     
        
//           let timeZone = TimeZone.init(identifier: "UTC")
//           let formatter = DateFormatter()
//           formatter.timeZone = timeZone
//           formatter.locale = Locale.init(identifier: "zh_CN")
//           formatter.dateFormat = dateFormat
//           let date = formatter.string(from: date)
//           return date.components(separatedBy: " ").first!
       }
    
    

    

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
