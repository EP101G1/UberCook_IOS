//
//  TotalOrderListViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/14.
//

import UIKit
import DatePickerDialog
import AVFoundation



class TotalOrderListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    let userDefault = UserDefaults()
    
    var nextMenuRecipeLists = [MenuRecipeList]()
    var chefNo:String?

    
    var sumtotal = 0
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var datepickerview: UIDatePicker!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var adrsTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var remarksTextView: UITextView!
    
    
    @IBOutlet weak var totalMoneyTextView: UILabel!
    
    
    
    @IBAction func completeButton(_ sender: Any) {
        
        /* 看轉換時間用
         let date: Date = Date() //取得當前時間
         let dateFormatter: DateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let nowdateString:String = dateFormatter.string(from: date) //把現在時間轉成字串
         let dateFormatString:String = dateFormatter.string(from: datepickerview.date) //取得訂單時間並轉成字串
         
         print("date: \(nowdateString)") //印出現在時間
         print("date: \(dateFormatString)") //印出預約時間
         */
        
        //把訂購人資訊包成物件
        let orderinfo = Order(order_no: nil, user_no: self.userDefault.value(forKey: "user_no")as! String, chef_no: chefNo!, remark: remarksTextView.text, order_date: Date(), flag: 0, deal_date: datepickerview.date, total_point: sumtotal, user_star: nil, chef_star: nil, address: adrsTextField.text!, phone: phoneTextField.text!, user_name: nameTextField.text!)
        
        
        
        //把訂單包成陣列
        var orderListinfo = [OrderList]()
        for index in 0...nextMenuRecipeLists.count-1  {
            
            let orderListoObj = OrderList(order_no: nil, recipe_no: nextMenuRecipeLists[index].recipeNo, point: nextMenuRecipeLists[index].recipePoint * nextMenuRecipeLists[index].count!, count: nextMenuRecipeLists[index].count!, recipe_title: nextMenuRecipeLists[index].recipeTitle)
            orderListinfo.append(orderListoObj) //把物件加進陣列
            
        }
        
        
        
       let OrderInsertObj = OrderObj(action: "InsertOrder", userName: nameTextField.text, order: orderinfo, orderList: orderListinfo)
        
        
        let baseURL = URL(string: "http://127.0.0.1:8080/UberCook_Server")!
        let url = baseURL.appendingPathComponent("Order_Servlet") //連網址
        var request = URLRequest(url: url) //送請求
        request.httpMethod = "POST" //包post
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //add key value
        let encoder = JSONEncoder() //編碼
      
        
        request.httpBody = try? encoder.encode(OrderInsertObj)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // print(String(decoding: data!, as: UTF8.self))
            //            print(String(decoding: data!, as: UTF8.self))
            let decoder = JSONDecoder()
            
            if let data = data,
               let point = try? decoder.decode(Int.self, from: data){
                //                print(menuRecipeList[0].chefNo)
                print(String(point))
            }else{
                
            }
        }.resume()
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = self.userDefault.value(forKey: "user_name") as? String
        adrsTextField.text = self.userDefault.value(forKey: "user_adrs") as? String
        phoneTextField.text = self.userDefault.value(forKey: "user_phone") as? String
        
        setBottomBorder()
        
      
        for index in 0...nextMenuRecipeLists.count-1{
            self.sumtotal += (nextMenuRecipeLists[index].recipePoint) * (self.nextMenuRecipeLists[index].count!)
        }
        totalMoneyTextView.text = "$"+String(sumtotal)
       
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nextMenuRecipeLists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TotalOrderListTableViewCell.self)", for: indexPath) as! TotalOrderListTableViewCell
        
        cell.titleLabel.text = nextMenuRecipeLists[indexPath.row].recipeTitle
        
        
        cell.numberLabel.text = String(self.nextMenuRecipeLists[indexPath.row].count!)
        
        cell.cashLabel.text = "$  "+String(nextMenuRecipeLists[indexPath.row].recipePoint * nextMenuRecipeLists[indexPath.row].count!)
        
        
        return cell
    }
    
    
    
   
    
    
    
    
    
    func setBottomBorder() {
        
        
        nameTextField.layer.backgroundColor = UIColor.white.cgColor
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.shadowColor = UIColor.gray.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        nameTextField.layer.shadowOpacity = 1.0
        nameTextField.layer.shadowRadius = 0.0
        
        adrsTextField.layer.backgroundColor = UIColor.white.cgColor
        adrsTextField.layer.masksToBounds = false
        adrsTextField.layer.shadowColor = UIColor.gray.cgColor
        adrsTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        adrsTextField.layer.shadowOpacity = 1.0
        adrsTextField.layer.shadowRadius = 0.0
        
        phoneTextField.layer.backgroundColor = UIColor.white.cgColor
        phoneTextField.layer.masksToBounds = false
        phoneTextField.layer.shadowColor = UIColor.gray.cgColor
        phoneTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        phoneTextField.layer.shadowOpacity = 1.0
        phoneTextField.layer.shadowRadius = 0.0
        
        remarksTextView.layer.backgroundColor = UIColor.white.cgColor
        remarksTextView.layer.masksToBounds = false
        remarksTextView.layer.shadowColor = UIColor.gray.cgColor
        remarksTextView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        remarksTextView.layer.shadowOpacity = 1.0
        remarksTextView.layer.shadowRadius = 0.0
    }
    
    
    
    
}





