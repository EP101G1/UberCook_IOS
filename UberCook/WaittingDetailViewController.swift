//
//  WaittingDetailViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/17.
//

import UIKit

class WaittingDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var orderList:Order?
    var orderinfoLists = [OrderList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getOrder()
       //print("no" ,orderList?.order_no)
        

        // Do any additional setup after loading the view.
      
        
    }
    
    func getOrder(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getOrderLists"
        requestParam["order_no"] = orderList?.order_no
        //print( orderList?.order_no)
    
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
    

    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//

}
