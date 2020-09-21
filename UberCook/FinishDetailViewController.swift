//
//  FinishDetailViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/21.
//

import UIKit

class FinishDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
    let userDefault = UserDefaults()
    var orderList:Order?
    var orderinfoLists = [OrderList]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var OrderDataTextField: UITextField!
    
    @IBOutlet weak var OrderNameTextField: UITextField!
    
    @IBOutlet weak var ardsTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var remarkTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOrder()
        let dateTostr = orderList?.order_date

        OrderDataTextField.text = dateConvertString(date: dateTostr!)
        OrderNameTextField.text = orderList?.user_name
        phoneTextField.text = orderList?.phone
        remarkTextView.text = orderList?.remark
        ardsTextField.text = orderList?.address
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderinfoLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WaittingDetailTableViewCell.self)", for: indexPath) as! WaittingDetailTableViewCell
        
        cell.NameLabel.text = orderinfoLists[indexPath.row].recipe_title
        cell.numberLabel.text = String(orderinfoLists[indexPath.row].count)
        cell.cashLabel.text = "$ "+String(orderinfoLists[indexPath.row].point)
    
        return cell
    
    }
    
    func getOrder(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getOrderLists"
        requestParam["order_no"] = self.orderList?.order_no
    
    
        executeTask(URL(string: common_url + "Order_Servlet")!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
                print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([OrderList].self, from: data!){
                        self.orderinfoLists = result
//                        print("\(self.orderList[0].deal_date) + !!!!!!!!!")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String { //date型態轉string
        
        let dateFormatter = DateFormatter() //設定時間格式

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
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
